extends Powerup

const FREQUENCY: int = 1 # 1

func apply_effect(): 
	MusicManager.play_random_song()
