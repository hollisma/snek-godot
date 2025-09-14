extends Powerup

const FREQUENCY: int = 1

func apply_effect_to_music(music_manager): 
	music_manager.play_random_song()
