extends Area2D
class_name Powerup

signal collected(powerup)

func _on_area_entered(area): 
	if area.is_in_group("snek_head"):
		emit_signal("collected", self)
		queue_free()
