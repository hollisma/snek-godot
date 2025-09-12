extends CanvasLayer

signal start_game

func _ready():
	show_message("Welcome to Snek :)")
	$StartButton.show()

func show_game_over(score): 
	show_message("You died with a score of %d" % score, 1)
	await $MessageTimer.timeout
	show_message("Play Again?")
	await get_tree().create_timer(0.75).timeout
	$StartButton.show()

func show_message(text, time_length := 0): 
	$MessageLabel.text = text
	$MessageLabel.show()
	if time_length > 0:
		$MessageTimer.start(time_length)

func update_score(score): 
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	start_game.emit()
