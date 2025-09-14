extends Node2D

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")
var snek_head: Node
@onready var screen_size = get_viewport().size

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
	
	var appl = appl_scene.instantiate()
	appl.position = pos
	call_deferred("add_child", appl)
