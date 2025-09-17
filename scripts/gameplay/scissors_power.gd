extends Powerup

const FREQUENCY: int = 2 # 2

func apply_effect_to_snek(snek): 
	var size_decrease_value = _get_size_decrease_value()
	snek.trim_body(size_decrease_value)

func _get_size_decrease_value() -> int:
	var rand = randi() % 100
	if rand < 60: 
		return 1
	if rand < 85: 
		return 2
	else: 
		return 3
