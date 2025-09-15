extends Powerup

const FREQUENCY: int = 2 # 1

func apply_effect(): 
	ThemeManager.toggle_theme()
