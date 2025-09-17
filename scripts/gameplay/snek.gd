extends Node2D

signal appl_eaten
signal snek_death

@export var default_speed: float = 175.0
@export var min_speed: float = 50.0
@export var collision_distance = 25.0
@export var segment_distance_constant = 2400.0

var speed = default_speed
var segment_distance = 46.0
var moving = false

# Store { position, distance }
var path_points: Array = []
var start_index: int = 0 # Buffer

var segments: Array[Node2D] = []
var direction: Vector2 = Vector2.RIGHT   # start moving right
@onready var screen_size = get_viewport().size
@onready var body_scene = preload(ResourcePaths.SCENES["body"])

func _ready(): 
	hide()

func _physics_process(delta):
	if not moving: 
		return
	handle_input()
	move(delta)
	update_segments()
	trim_path()
	check_boundary()
	check_self_collision()

func start(): 
	speed = default_speed
	moving = true
	show()

func reset(): 
	hide()
	path_points.clear()
	for segment in segments: 
		segment.queue_free()
	segments.clear()
	direction = Vector2.RIGHT
	$Head.rotation = 0
	$Head.global_position = Vector2(10, screen_size.y / 2)

func handle_input():
	if Input.is_action_pressed("move_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
		$Head.rotation = -PI / 2
	elif Input.is_action_pressed("move_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
		$Head.rotation = PI / 2
	elif Input.is_action_pressed("move_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
		$Head.rotation = PI
	elif Input.is_action_pressed("move_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT
		$Head.rotation = 0

func move(delta): 
	var old_pos = $Head.position
	$Head.position += direction * speed * delta
	
	var distance_moved = $Head.position.distance_to(old_pos)
	var cumulative_distance = distance_moved
	if _get_size() > 0: 
		cumulative_distance += _get_point(_get_size() - 1).distance
	
	path_points.append({ 
		"position": $Head.position, 
		"distance": cumulative_distance 
	})

func update_segments(): 
	if _get_size() == 0: 
		return
	
	# Update positions
	var starting_distance = _get_point(_get_size() - 1).distance
	for i in range(segments.size()):
		var target_distance = starting_distance - (i + 1) * segment_distance
		var pos = _get_position_at_distance(target_distance)
		segments[i].position = pos
		
		# Apply rotation based on next segment
		var dir: Vector2
		if i == 0: 
			dir = $Head.position - pos
		else: 
			dir = segments[i - 1].position - pos
		if dir.length_squared() > 0.0001: 
			segments[i].rotation = dir.angle()

func trim_path(): 
	if _get_size() == 0: 
		return
	
	var segments_length = segment_distance * (segments.size() + 1)
	var min_distance_to_keep = _get_point(_get_size() - 1).distance - segments_length
	while _get_size() > 1 and _get_point(1).distance < min_distance_to_keep:
		start_index += 1
	
	# Actually clean points occasionally
	if start_index > 100 and start_index > path_points.size() / 2.0: 
		path_points = path_points.slice(start_index, path_points.size())
		start_index = 0

func check_boundary(): 
	var head_pos = $Head.global_position
	if head_pos.x < 0 or head_pos.x > screen_size.x or head_pos.y < 0 or head_pos.y > screen_size.y: 
		snek_death.emit()

func check_self_collision(): 
	var safe_distance = 1 # Colliding with first N segments is safe
	for i in range(safe_distance, segments.size()): 
		if $Head.global_position.distance_to(segments[i].global_position) < collision_distance: 
			snek_death.emit()
			break

func grow(): 
	var new_segment = body_scene.instantiate()
	$BodySegments.call_deferred("add_child", new_segment)
	segments.append(new_segment)

func stop(): 
	moving = false

func change_speed(speed_change): 
	speed = max(speed + speed_change, min_speed)

func trim_body(segment_num_input): 
	var segment_num = min(segment_num_input, segments.size())
	for i in range(segment_num): 
		var last_segment = segments.pop_back()
		if last_segment: 
			last_segment.queue_free()

func _get_position_at_distance(target_distance: float) -> Vector2:
	# Boundary checks
	if _get_size() == 0:
		return $Head.position
	if target_distance < _get_point(0).distance: 
		return _get_point(0).position
	if target_distance > _get_point(_get_size() - 1).distance: 
		return _get_point(_get_size() - 1).position
	
	# Binary search
	var low = 0
	var high = _get_size() - 1
	while low <= high: 
		var mid = (low + high) >> 1
		var mid_point = _get_point(mid)
		if mid_point.distance == target_distance: 
			return mid_point.position
		elif mid_point.distance < target_distance: 
			low = mid + 1
		else: 
			high = mid - 1
	
	# Lerp
	var p0 = _get_point(high)
	var p1 = _get_point(low)
	var t = (target_distance - p0.distance) / (p1.distance - p0.distance)
	return p0.position.lerp(p1.position, t)

func _on_head_area_entered(area):
	if area.is_in_group("appls"): 
		grow()
		emit_signal("appl_eaten", area)

# Buffer helpers
func _get_size() -> int: 
	return path_points.size() - start_index

func _get_point(i: int) -> Dictionary: 
	return path_points[start_index + i]
