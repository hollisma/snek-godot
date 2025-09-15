extends Node2D

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")
var appl_green_scene: PackedScene = preload("res://scenes/appl_green.tscn")
var appl_golden_scene: PackedScene = preload("res://scenes/appl_golden.tscn")

const GOLDEN_APPL_TIME = 5.0 # 5.0 secs

var snek_head: Node
var golden_appl: Node
@onready var screen_size = get_viewport().size
@onready var golden_appl_timer = $GoldenApplTimer

func spawn_appl(): 
	var margin = 16
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (screen_size.x - 2 * margin) + margin
		var y = randf() * (screen_size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		if snek_head.position.distance_to(pos) > margin * 2: 
			break
	
	var appl = _get_appl_instance()
	appl.position = pos
	call_deferred("add_child", appl)

func _get_appl_instance() -> Node:
	var rand = randi() % 100
	var appl: Node
	if rand < 15: # 15% chance to be green
		appl = appl_green_scene.instantiate()
	elif rand < 20: # 5% chance to be golden
		appl = appl_golden_scene.instantiate()
		start_golden_appl(appl)
	else: 
		appl = appl_scene.instantiate()
	return appl

func start_golden_appl(appl): 
	golden_appl = appl
	var tween = create_tween()
	tween.tween_property(appl, "modulate:a", 0.0, GOLDEN_APPL_TIME)
	golden_appl_timer.start(GOLDEN_APPL_TIME)

func _on_GoldenApplTimer_timeout():
	if golden_appl and is_instance_valid(golden_appl): 
		golden_appl.queue_free()
		golden_appl = null
		spawn_appl()
