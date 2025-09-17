extends Control

@onready var level_buttons = $VBoxContainer/LevelButtons
@onready var back_button = $VBoxContainer/BottomContainer/BackButton

signal level_chosen(level_id: String)

func _ready():
	_populate_levels()

func _populate_levels(): 
	for child in level_buttons.get_children(): 
		child.queue_free()
	
	for level_id in LevelManager.levels.keys(): 
		var button = Button.new()
		button.text = LevelManager.levels[level_id]["name"]
		button.custom_minimum_size = Vector2(250, 100)
		button.pressed.connect(_on_level_selected.bind(level_id))
		level_buttons.add_child(button)

func _on_level_selected(level_id: String): 
	emit_signal("level_chosen", level_id)
