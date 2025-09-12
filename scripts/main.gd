extends Node

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")
var score

func new_game():
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("appls", "queue_free")
	$snek.reset()
	$snek.start()
	spawn_appl()
	
func spawn_appl(): 
	var margin = 16
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (get_viewport().size.x - 2 * margin) + margin
		var y = randf() * (get_viewport().size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		
		# Check appl distance to snek
		var too_close = false
		var snek_nodes = $snek.segments.duplicate()
		snek_nodes.append($snek/Head)
		for segment in snek_nodes: 
			if segment.position.distance_to(pos) < margin * 2: 
				too_close = true
				break
		
		if not too_close: 
			break
	
	var appl = appl_scene.instantiate()
	appl.position = pos
	call_deferred("add_child", appl)

func _on_appl_eaten(): 
	spawn_appl()
	score += 1
	$HUD.update_score(score)

func _on_snek_death(): 
	$snek.stop()
	$HUD.show_game_over(score)
