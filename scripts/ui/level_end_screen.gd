extends Control

signal replay_pressed
signal level_select_pressed
signal next_level_pressed

@onready var message_label: Label = $VBox/MessageLabel
@onready var score_label: Label = $VBox/ScoreLabel
@onready var replay_button: Button = $VBox/Buttons/ReplayButton
@onready var level_select_button: Button = $VBox/Buttons/LevelSelectButton
@onready var next_button: Button = $VBox/Buttons/NextButton

func _ready(): 
	replay_button.text = "Replay"
	replay_button.pressed.connect(func(): emit_signal("replay_pressed"))
	level_select_button.text = "Levels"
	level_select_button.pressed.connect(func(): emit_signal("level_select_pressed"))
	next_button.text = "Next"
	next_button.pressed.connect(func(): emit_signal("next_level_pressed"))

func show_score(score: int): 
	score_label.text = "Score: %d" % score
	score_label.visible = true

func apply_outcome(level_won: bool): 
	if not level_won: 
		next_button.disabled = true
		message_label.text = "Unlucky"
	else: 
		message_label.text = "Congrats!"
