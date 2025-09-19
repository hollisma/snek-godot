extends Control

@onready var level_buttons = $VBoxContainer/LevelButtons
@onready var back_button = $VBoxContainer/BottomContainer/BackButton

signal level_chosen(level_id: String)
signal level_select_back_pressed

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	_populate_levels()

func _populate_levels(): 
	for child in level_buttons.get_children(): 
		child.queue_free()
	
	for level_id in LevelManager.levels.keys(): 
		var button = Button.new()
		button.text = _get_name_for_level(level_id)
		button.custom_minimum_size = Vector2(225, 90)
		button.pressed.connect(_on_level_selected.bind(level_id))
		level_buttons.add_child(button)

func _get_name_for_level(level_id) -> String: 
	var level_name = LevelManager.levels[level_id]["name"]
	if ProgressManager.is_level_beaten(level_id): 
		level_name = "✅ " + level_name
	return level_name

func _on_level_selected(level_id: String): 
	emit_signal("level_chosen", level_id)

func _on_back_pressed(): 
	level_select_back_pressed.emit()
