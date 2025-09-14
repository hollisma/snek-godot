extends Node2D

signal appl_eaten
signal snek_death

@export var default_speed: float = 175.0
@export var min_speed: float = 50.0
@export var collision_distance = 25.0
@export var segment_distance_constant = 2400.0

var speed = default_speed
var segment_distance = segment_distance_constant / speed
var moving = false

var path_points: Array[Vector2] = []
var segments: Array[Node2D] = []
var direction: Vector2 = Vector2.RIGHT   # start moving right
@onready var screen_size = get_viewport().size

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
	path_points.clear()
	for segment in $BodySegments.get_children(): 
		segment.queue_free()
	segments.clear()
	direction = Vector2.RIGHT
	$Head.rotation = 0
	$Head.global_position = Vector2(10, screen_size.y / 2)

func move(delta): 
	$Head.position += direction * speed * delta
	path_points.insert(0, $Head.position)

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

func update_segments(): 
	var distance = 0.0
	for segment in segments: 
		distance += segment_distance
		if distance < path_points.size(): 
			segment.position = path_points[distance]
			# Rotate segment to face the next point in path
			if distance + 1 < path_points.size(): 
				var next_pos = path_points[distance - 1]
				segment.rotation = (next_pos - segment.position).angle()

func trim_path(): 
	var max_path_needed = int(segment_distance * (segments.size() + 1))
	if path_points.size() > max_path_needed: 
		path_points.resize(max_path_needed)

func check_boundary(): 
	var head_pos = $Head.global_position
	if head_pos.x < 0 or head_pos.x > screen_size.x or head_pos.y < 0 or head_pos.y > screen_size.y: 
		snek_death.emit()

func check_self_collision(): 
	var body_children = $BodySegments.get_children()
	var safe_distance = 1
	for i in range(safe_distance, body_children.size()): 
		if $Head.global_position.distance_to(body_children[i].global_position) < collision_distance: 
			snek_death.emit()
			break

func grow(): 
	var body_scene = preload("res://scenes/body.tscn")
	var new_segment = body_scene.instantiate()
	$BodySegments.call_deferred("add_child", new_segment)
	segments.append(new_segment)

func stop(): 
	moving = false

func change_speed(speed_change): 
	speed = max(speed + speed_change, min_speed)
	segment_distance = segment_distance_constant / speed

func _on_head_area_entered(area):
	if area.is_in_group("appls"): 
		area.queue_free()
		grow()
		appl_eaten.emit()
