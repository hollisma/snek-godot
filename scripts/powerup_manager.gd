extends Node2D

@export var powerup_scenes: Array[PackedScene]

var spawn_time_min = 3 # 3
var spawn_time_max = 7 # 7

@onready var powerup_timer = $PowerupTimer
var snek: Node
var snek_head: Node
var music_manager: Node

func start_spawning(): 
	_restart_timer()

func _on_powerup_timer_timeout():
	spawn_powerup()
	_restart_timer()

func _restart_timer():
	var spawn_time = randi_range(spawn_time_min, spawn_time_max)
	powerup_timer.start(spawn_time)

func spawn_powerup(): 
	if powerup_scenes.size() == 0: 
		return
	
	var scene = powerup_scenes.pick_random()
	var powerup = scene.instantiate()
	powerup.global_position = _get_spawn_location()
	
	call_deferred("add_child", powerup)
	powerup.collected.connect(_on_powerup_collected)

func _get_spawn_location(): 
	var margin = 16
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (get_viewport().size.x - 2 * margin) + margin
		var y = randf() * (get_viewport().size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		if snek_head.position.distance_to(pos) > margin * 2: 
			break
	
	return pos

func _on_powerup_collected(powerup): 
	print("powerup collected: %s" % powerup)
	if powerup.has_method("apply_effect_to_snek") and snek != null: 
		powerup.apply_effect_to_snek(snek)
	if powerup.has_method("apply_effect_to_music") and music_manager != null: 
		powerup.apply_effect_to_music(music_manager)
	powerup.queue_free()
