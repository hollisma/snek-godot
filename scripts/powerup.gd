extends Area2D
class_name Powerup

@export var duration: float = 8.0
@export var powerup_type: String = "generic"

signal collected(powerup)

func _on_area_entered(area): 
	if area.is_in_group("snek_head"):
		emit_signal("collected", self)
		queue_free()
