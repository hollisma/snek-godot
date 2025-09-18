extends Powerup

const FREQUENCY: int = 4
var speed_increase: float = 1.0

func apply_effect_to_snek(snek): 
	snek.change_speed(speed_increase)
