extends Powerup

@export var size_decrease_min: int = 1
@export var size_decrease_max: int = 3
const FREQUENCY: int = 2

func apply_effect_to_snek(snek): 
	var size_decrease_value = randi_range(size_decrease_min, size_decrease_max)
	snek.trim_body(size_decrease_value)
