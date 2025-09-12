extends Node2D

@export var powerup_scenes: Array[PackedScene]

var snek: Node

func spawn_powerup(): 
	if powerup_scenes.size() == 0: 
		return
	
	var scene = powerup_scenes.pick_random()
	var powerup = scene.instantiate()
	
	var screen_size = get_viewport().size
	powerup.global_position = Vector2(
		randi_range(50, screen_size.x - 50),
		randi_range(50, screen_size.y - 50)
	)
	
	call_deferred("add_child", powerup)
	powerup.collected.connect(_on_powerup_collected)

func _on_powerup_collected(powerup): 
	print("powerup collected: %s" % powerup)
	if powerup.has_method("apply_effect") and snek != null: 
		powerup.apply_effect(snek)
	powerup.queue_free()
