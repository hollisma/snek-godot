extends Node

enum GameState { MAIN_MENU, LEVEL_SELECT, IN_GAME, LEVEL_END_SCREEN }

var appl_scene: PackedScene = preload(ResourcePaths.SCENES["appl"])

@onready var gameplay_container = $GameplayContainer
@onready var ui_container = $UIContainer
@onready var snek = $GameplayContainer/Snek
@onready var snek_head = $GameplayContainer/Snek/Head
@onready var food_manager = $GameplayContainer/FoodManager
@onready var powerup_manager = $GameplayContainer/PowerupManager
@onready var theme_manager = $GameplayContainer/ThemeManager
@onready var objective_manager = $GameplayContainer/ObjectiveManager
var hud: CanvasLayer

var score: int = -1
var game_state: GameState = GameState.MAIN_MENU

func _ready(): 
	food_manager.snek_head = snek_head
	powerup_manager.snek = snek
	powerup_manager.snek_head = snek_head
	
	MusicManager.start()
	_show_main_menu()

#############
### MENUS ###
#############

func _show_main_menu(): 
	clear_node(ui_container)
	var main_menu = preload(ResourcePaths.SCENES["main_menu"]).instantiate()
	ui_container.add_child(main_menu)
	main_menu.on_main_menu_play.connect(_on_main_menu_play)
	main_menu.on_main_menu_quit.connect(_on_main_menu_quit)
	game_state = GameState.MAIN_MENU

func _show_level_select(): 
	_reset_gameplay_container()
	clear_node(ui_container)
	var level_select = preload(ResourcePaths.SCENES["level_select"]).instantiate()
	ui_container.add_child(level_select)
	level_select.level_chosen.connect(_on_level_chosen)
	level_select.level_select_back_pressed.connect(_show_main_menu)
	game_state = GameState.LEVEL_SELECT

func _create_hud(): 
	clear_node(ui_container)
	hud = preload(ResourcePaths.SCENES["hud"]).instantiate()
	ui_container.add_child(hud)

func _do_level_end_screen(level_won: bool): 
	if game_state != GameState.IN_GAME: 
		return
	
	clear_node(ui_container)
	var level_end_screen = preload(ResourcePaths.SCENES["level_end_screen"]).instantiate()
	ui_container.add_child(level_end_screen)
	
	level_end_screen.show_score(score)
	level_end_screen.replay_pressed.connect(func(): _replay_level())
	level_end_screen.level_select_pressed.connect(func(): _show_level_select())
	level_end_screen.next_level_pressed.connect(func(): _start_next_level())
	
	level_end_screen.apply_outcome(level_won)
	game_state = GameState.LEVEL_END_SCREEN

##################
### MENU LOGIC ###
##################

func _on_level_chosen(level_id: String): 
	clear_node(ui_container)
	_reset_gameplay_container()
	_create_hud()
	
	objective_manager.condition_updated.connect(hud.update_score_display)
	LevelManager.start_level(objective_manager, powerup_manager, food_manager, level_id)
	_update_score(0)
	snek.start()
	game_state = GameState.IN_GAME

func _replay_level(): 
	_on_level_chosen(LevelManager.current_level_id)

func _start_next_level(): 
	# TODO: Implement this
	_on_level_chosen(LevelManager.current_level_id)

func _on_main_menu_play(): 
	_show_level_select()

func _on_main_menu_quit(): 
	get_tree().quit()

########################
### GAMEPLAY SIGNALS ###
########################

func _on_objectives_completed(outcome): 
	if outcome == GameEnums.Outcome.WIN: 
		_do_level_end_screen(true)
		ProgressManager.mark_level_beaten(LevelManager.current_level_id)
	elif outcome == GameEnums.Outcome.LOSE: 
		_do_level_end_screen(false)

func _on_appl_eaten(appl): 
	food_manager.spawn_appl()
	var new_score = score + appl.points
	_update_score(new_score)
	appl.queue_free()

func _on_snek_death(): 
	snek.stop()
	powerup_manager.stop()
	_do_level_end_screen(false)

func _on_snek_length_changed(length):
	objective_manager.update_condition(GameEnums.ConditionType.LENGTH, length)

func _on_snek_speed_changed(speed): 
	objective_manager.update_condition(GameEnums.ConditionType.SPEED, speed)

###############
### HELPERS ###
###############

func clear_node(node: Node):
	for child in node.get_children(): 
		child.queue_free()

func _reset_gameplay_container(): 
	get_tree().call_group("appls", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	snek.reset()
	score = 0

func _update_score(new_score: int): 
	score = new_score
	objective_manager.update_condition(GameEnums.ConditionType.SCORE, score)

# DEV buttons
func _process(_delta):
	if Input.is_action_just_pressed("dev 1"):
		MusicManager.play_random_song()
	if Input.is_action_just_pressed("dev 2"):
		powerup_manager.__test(1)
	if Input.is_action_just_pressed("dev 3"):
		snek.grow()
	if Input.is_action_just_pressed("dev 4"):
		pass
