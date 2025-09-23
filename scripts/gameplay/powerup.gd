extends Area2D
class_name Powerup

signal collected(powerup)

@export var fade_delay_seconds: float = GameConsts.POWERUP_FADE_DELAY_SECONDS
@export var fade_duration_seconds: float = GameConsts.POWERUP_FADE_DURATION_SECONDS

@onready var sprite: Sprite2D = $Sprite2D

func _ready(): 
	_start_fade_lifecycle()

func _on_area_entered(area): 
	if area.is_in_group("snek_head"):
		emit_signal("collected", self)
		queue_free()

func _start_fade_lifecycle(): 
	# Phase 1: Full opacity
	await get_tree().create_timer(fade_delay_seconds).timeout
	if !is_instance_valid(self) or !is_inside_tree(): 
		return
	
	# Phase 2: Fade
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, fade_duration_seconds)
	await tween.finished
	if is_inside_tree(): 
		queue_free()
