extends CanvasLayer

func show_message(text, time_length := 0): 
	$MessageLabel.text = text
	$MessageLabel.show()
	if time_length > 0:
		$MessageTimer.start(time_length)

func update_score(score): 
	$ScoreLabel.text = str(score)
	$ScoreLabel.visible = true

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
