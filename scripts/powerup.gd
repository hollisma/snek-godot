extends Area2D
class_name Powerup

@export var duration: float = 8.0
@export var powerup_type: String = "generic"
@export var frequency: int = 1

signal collected(powerup)

func _on_area_entered(area): 
	if area.is_in_group("snek_head"):
		emit_signal("collected", self)
		queue_free()

func apply_effect_to_snek(snek: Node): 
	pass

func apply_effect_to_music(music_manager: Node): 
	pass
