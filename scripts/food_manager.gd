extends Node2D

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")

func spawn_appl(snek, snek_head): 
	var margin = 16
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (get_viewport().size.x - 2 * margin) + margin
		var y = randf() * (get_viewport().size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		
		# Check appl distance to snek
		var too_close = false
		var snek_nodes = snek.segments.duplicate()
		snek_nodes.append(snek_head)
		for segment in snek_nodes: 
			if segment.position.distance_to(pos) < margin * 2: 
				too_close = true
				break
		
		if not too_close: 
			break
	
	var appl = appl_scene.instantiate()
	appl.position = pos
	call_deferred("add_child", appl)
