extends Powerup

@export var speed_increase: float = 30.0

func apply_effect(player): 
	player.change_speed(speed_increase)
