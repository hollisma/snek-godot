extends Node

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")
var score

@onready var snek = $snek
@onready var snek_head = $snek/Head
@onready var hud = $HUD
@onready var food_manager = $FoodManager
@onready var powerup_manager = $PowerupManager

func _ready(): 
	powerup_manager.snek = snek

func new_game():
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("appls", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	$snek.reset()
	$snek.start()
	food_manager.spawn_appl(snek, snek_head)

func _on_appl_eaten(): 
	food_manager.spawn_appl(snek, snek_head)
	powerup_manager.spawn_powerup()
	score += 1
	hud.update_score(score)

func _on_snek_death(): 
	snek.stop()
	hud.show_game_over(score)
