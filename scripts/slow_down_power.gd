extends Powerup

@export var speed_decrease: float = -30.0

func apply_effect(player): 
	player.change_speed(speed_decrease)
