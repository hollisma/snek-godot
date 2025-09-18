extends Node

var current_level_id: String = ""
var data: Dictionary = {}

func set_level(level_id: String): 
	if not levels.has(level_id): 
		push_error("Level does not exist: ", level_id)
		return
	print("Setting level ", level_id)
	current_level_id = level_id
	data = levels[level_id]

# If `level_id` is provided, it will set and start that level.
# Otherwise, it assumes a level has already been set with set_level().
func start_level(objective_manager: Node, powerup_manager: Node, food_manager: Node, level_id: String = ""): 
	if level_id != "": 
		if not levels.has(level_id): 
			push_error("Level does not exist: ", level_id)
			return
		set_level(level_id)
	elif current_level_id == "": 
		push_error("Error: no level set. Call set_level() or pass valid level_id")
	
	print("Starting level ", level_id)	
	MusicManager.play_song(load(data["music"]))
	objective_manager.apply_level_data(data)
	powerup_manager.apply_level_data(data)
	powerup_manager.start_spawning()
	food_manager.spawn_appl()

func NOT_USED_get_current_level_data() -> Dictionary: 
	if current_level_id == "": 
		return {}
	return levels[current_level_id]

var levels = {
	"normal": {
		"name": "Normal",
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 50, # 50
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["default"], 
		"powerups": {
			"speed": 4,
			"slow": 4,
			"scissors": 2,
			"music": 1,
			"visuals": 1,
		}
	},
	"feeding_time": {
		"name": "Feeding Time", 
		"win_cons": [
			{
				"con_type": "length",
				"comparator": "over",
				"value": 25, # 25
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["feeding_time"], 
		"powerups": {
			"speed": 2,
			"slow": 2,
			"scissors": 3,
			"visuals": 5, # "fatten": 5,
		}
	},
	"easy_score": {
		"name": "easy_score", 
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 3,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["feeding_time"], 
		"powerups": {
			"speed": 4,
			"slow": 4,
			"scissors": 2,
			"music": 1,
			"visuals": 1,
		}
	},
	"easy_score_lose": {
		"name": "easy_score_lose", 
		"win_cons": [],
		"lose_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 3,
			},
		],
		"music": ResourcePaths.MUSIC["feeding_time"], 
		"powerups": {
			"speed": 4,
			"slow": 4,
			"scissors": 2,
			"music": 1,
			"visuals": 1,
		}
	},
}
