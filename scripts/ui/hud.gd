extends CanvasLayer

@onready var message_label = $MessageLabel
@onready var score_label = $ScoreLabel
@onready var message_timer = $MessageTimer

func show_message(text, time_length := 0): 
	message_label.text = text
	message_label.show()
	if time_length > 0:
		message_timer.start(time_length)

func update_score_display(con_type, current, target): 
	var label_text = ""
	match con_type: 
		GameEnums.ConditionType.SCORE: 
			label_text = "Score: %d/%d" % [current, target]
		GameEnums.ConditionType.LENGTH: 
			label_text = "Length: %d/%d" % [current, target]
		GameEnums.ConditionType.SPEED: 
			label_text = "Speed: %d/%d" % [current, target]
	score_label.text = label_text
	score_label.visible = true

func _on_MessageTimer_timeout():
	message_label.hide()
