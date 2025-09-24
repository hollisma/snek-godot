extends Node

var current_level_id: String = ""
var data: Dictionary = {}

func set_level(level_id: String): 
	if not levels.has(level_id): 
		push_error("Level does not exist: ", level_id)
		return
	print("Setting level: ", level_id)
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
	
	print("Starting level: ", level_id)	
	MusicManager.play_song(load(data["music"]))
	objective_manager.apply_level_data(data)
	powerup_manager.apply_level_data(data)
	powerup_manager.start_spawning()
	food_manager.apply_level_data(data)
	food_manager.spawn_appl()

func get_next_level_id(level_id: String = current_level_id) -> String: 
	var index = level_order.find(level_id)
	if index == -1 or index == level_order.size() - 1: 
		return ""
	return level_order[index + 1]

var level_order = ["easy_score", "medium_score", "hard_score", "normal", "feeding_time", "escape", "easy_len", "easy_len_lose", "all_powerups", "random_b"]
#var level_order = ["easy_len", "feeding_time"]
#var level_order = ["normal", "feeding_time", "escape"]

### List of Attributes
		#"name": "All Powerups", 
		#"win_cons": [
			#{
				#"con_type": "length",
				#"comparator": "over",
				#"value": 10,
			#},
		#],
		#"lose_cons": [
			#{
				#"con_type": "speed",
				#"comparator": "over",
				#"value": 10,
			#},
		#],
		#"music": ResourcePaths.MUSIC["feeding_time"], 
		#"powerups": {
			#"speed": 1,
			#"slow": 1,
			#"scissors": 1,
			#"fatten": 1,
			#"music": 1,
			#"visuals": 1,
		#},
		#"powerup_spawn": { "min": 2, "max": 5 },
		#"powerup_fade": { "delay": 10, "duration": 5 },
		#"foods": {
			#"appl": 80,
			#"appl green": 15,
			#"appl golden": 5,
		#},

var levels = {
	"easy_score": {
		"name": "Easy Score",
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 10,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["default"], 
		"powerups": {},
		"powerup_spawn": { "min": 5, "max": 7 },
		"powerup_fade": { "delay": 15, "duration": 5 },
		"foods": { "appl": 1 },
	},
	"medium_score": {
		"name": "Medium Score",
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 25,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["default"], 
		"powerups": {
			"speed": 4,
			"slow": 2,
		},
		"powerup_spawn": { "min": 3, "max": 5 },
		"foods": {
			"appl": 5,
			"appl green": 1,
		},
	},
	"hard_score": {
		"name": "Hard Score",
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 50,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["default"], 
		"powerups": {
			"speed": 3,
			"slow": 3,
			"scissors": 1,
			"fatten": 3,
		},
		"powerup_spawn": { "min": 1, "max": 3 },
		"powerup_fade": { "delay": 7, "duration": 5 },
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
			"fatten": 5,
		},
		"powerup_spawn": { "min": 1, "max": 2 },
		"powerup_fade": { "delay": 15, "duration": 5},
		"foods": {
			"appl": 5,
			"appl green": 2,
			"appl golden": 1,
		},
	},
	"escape": {
		"name": "Escape", 
		"win_cons": [
			{
				"con_type": "speed",
				"comparator": "over",
				"value": 20,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["escape"], 
		"powerups": {
			"speed": 4,
			"slow": 3,
			"scissors": 1,
			"fatten": 1,
		},
		"powerup_spawn": { "min": 1, "max": 1 },
		"powerup_fade": { "delay": 7, "duration": 3},
		"food": { "appl": 1 },
	},
	
	##################
	### Dev levels ###
	##################
	
	"easy_len": {
		"name": "easy_len", 
		"win_cons": [
			{
				"con_type": "length",
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
		},
	},
	"easy_len_lose": {
		"name": "easy_len_lose", 
		"win_cons": [
			{
				"con_type": "score",
				"comparator": "over",
				"value": 1,
			},
		],
		"lose_cons": [
			{
				"con_type": "length",
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
		},
	},
	"all_powerups": {
		"name": "All Powerups", 
		"win_cons": [
			{
				"con_type": "length",
				"comparator": "over",
				"value": 10,
			},
		],
		"lose_cons": [],
		"music": ResourcePaths.MUSIC["feeding_time"], 
		"powerups": {
			"speed": 1,
			"slow": 1,
			"scissors": 1,
			"fatten": 1,
			"music": 1,
			"visuals": 1,
		},
		"powerup_spawn": { "min": 1, "max": 1 },
		"powerup_fade": { "delay": 2, "duration": 1},
	},
	"random_b": {
		"name": "Random B", 
		"win_cons": [],
		"lose_cons": [
			{
				"con_type": "length",
				"comparator": "over",
				"value": 10,
			},
		],
		"music": ResourcePaths.MUSIC["feeding_time"], 
		"powerups": {
			"speed": 4,
			"slow": 4,
			"scissors": 2,
			"music": 1,
			"visuals": 1,
		},
	},
}
