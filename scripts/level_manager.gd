extends Node

var current_level_id: String = ""
var data: Dictionary = {}

func start_level(level_id: String, powerup_manager: Node, food_manager: Node) -> void: 
	if not levels.has(level_id): 
		print("Level does not exist: ", level_id)
		return
	
	print("Starting level ", level_id)
	current_level_id = level_id
	data = levels[level_id]
	
	MusicManager.play_song(load(data["music"]))
	powerup_manager.apply_level_data(data)
	powerup_manager.start_spawning()
	food_manager.spawn_appl()

func NOT_USED_get_current_level_data() -> Dictionary: 
	if current_level_id == "": 
		return {}
	return levels[current_levessal_id]

var levels = {
	"normal": {
		"win_con": "score", 
		"win_value": 25,
		"music": "res://music/Running.ogg", 
		"powerups": {
			"speed": 4,
			"slow": 4,
			"scissors": 2,
			"music": 1,
			"visuals": 1,
		}
	},
	"feeding_time": {
		"win_con": "length", 
		"win_value": 25,
		"music": "res://music/Arpeggio with beats.ogg", 
		"powerups": {
			"speed": 2,
			"slow": 2,
			"scissors": 3,
			"visuals": 5, # "fatten": 5,
		}
	}
}
