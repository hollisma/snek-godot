extends Node

var appl_scene: PackedScene = preload("res://scenes/appl.tscn")
var score

@onready var snek = $snek
@onready var snek_head = $snek/Head
@onready var hud = $HUD
@onready var food_manager = $FoodManager
@onready var powerup_manager = $PowerupManager
@onready var theme_manager = $ThemeManager

func _ready(): 
	food_manager.snek_head = snek_head
	powerup_manager.snek = snek
	powerup_manager.snek_head = snek_head
	powerup_manager.theme_manager = theme_manager
	MusicManager.start()

func _process(_delta):
	if Input.is_action_just_pressed("dev 1"):
		MusicManager.play_random_song()
	if Input.is_action_just_pressed("dev 2"):
		powerup_manager.__test(1)
	if Input.is_action_just_pressed("dev 3"):
		snek.grow()
	if Input.is_action_just_pressed("dev 4"):
		pass

func new_game():
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("appls", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	$snek.reset()
	$snek.start()
	food_manager.spawn_appl()
	powerup_manager.start_spawning()

func _on_appl_eaten(appl): 
	food_manager.spawn_appl()
	score += appl.points
	hud.update_score(score)
	appl.queue_free()

func _on_snek_death(): 
	snek.stop()
	hud.show_game_over(score)
	powerup_manager.stop()
