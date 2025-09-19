extends Control

signal on_main_menu_play
signal on_main_menu_quit

@onready var play_button = $VBox/PlayButton
@onready var quit_button = $VBox/QuitButton

func _ready():
	play_button.pressed.connect(func(): on_main_menu_play.emit())
	quit_button.pressed.connect(func(): on_main_menu_quit.emit())
