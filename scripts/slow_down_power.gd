extends Powerup

@export var speed_decrease: float = -30.0
const FREQUENCY: int = 3

func apply_effect_to_snek(snek): 
	snek.change_speed(speed_decrease)
