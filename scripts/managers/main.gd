extends Node

var appl_scene: PackedScene = preload(ResourcePaths.SCENES["appl"])
var score

@onready var gameplay_container = $GameplayContainer
@onready var ui_container = $UIContainer
@onready var snek = $GameplayContainer/Snek
@onready var snek_head = $GameplayContainer/Snek/Head
@onready var food_manager = $GameplayContainer/FoodManager
@onready var powerup_manager = $GameplayContainer/PowerupManager
@onready var theme_manager = $GameplayContainer/ThemeManager
@onready var objective_manager = $GameplayContainer/ObjectiveManager
var hud: CanvasLayer

func _ready(): 
	MusicManager.start()
	_show_level_select()

#############
### MENUS ###
#############

func _create_hud(): 
	clear_node(ui_container)
	hud = preload(ResourcePaths.SCENES["hud"]).instantiate()
	ui_container.add_child(hud)

func _show_level_select(): 
	_reset_gameplay_container()
	clear_node(ui_container)
	var level_select = preload(ResourcePaths.SCENES["level_select"]).instantiate()
	ui_container.add_child(level_select)
	level_select.level_chosen.connect(_on_level_chosen)

func _do_level_end_screen(): 
	var level_end_screen = preload(ResourcePaths.SCENES["level_end_screen"]).instantiate()
	ui_container.add_child(level_end_screen)
	
	level_end_screen.show_score(score)
	level_end_screen.replay_pressed.connect(func(): _replay_level())
	level_end_screen.level_select_pressed.connect(func(): _show_level_select())
	level_end_screen.next_level_pressed.connect(func(): _start_next_level())

##################
### MENU LOGIC ###
##################

func _on_level_chosen(level_id: String): 
	clear_node(ui_container)
	_create_hud()
	
	score = 0
	hud.update_score(score)
	get_tree().call_group("appls", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	snek.reset()
	
	food_manager.snek_head = snek_head
	powerup_manager.snek = snek
	powerup_manager.snek_head = snek_head
	snek.start()
	
	LevelManager.start_level(objective_manager, powerup_manager, food_manager, level_id)

func _replay_level(): 
	_on_level_chosen(LevelManager.current_level_id)

func _start_next_level(): 
	# TODO: Implement this
	_on_level_chosen(LevelManager.current_level_id)

########################
### GAMEPLAY SIGNALS ###
########################

func _on_appl_eaten(appl): 
	food_manager.spawn_appl()
	score += appl.points
	hud.update_score(score)
	objective_manager.update_condition(objective_manager.ConditionType.SCORE, score)
	appl.queue_free()

func _on_snek_death(): 
	snek.stop()
	powerup_manager.stop()
	_do_level_end_screen()

func _on_objectives_completed(outcome): 
	if outcome == objective_manager.Outcome.WIN: 
		print("Winner Winner CHicken Dinner!!!")
	elif outcome == objective_manager.Outcome.LOSE: 
		print("Loserrrrr")

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
