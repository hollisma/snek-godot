extends Node

const SAVE_FILENAME = "user://progress.save"

var level_beaten: Dictionary = {}

func mark_level_beaten(level_id: String): 
	level_beaten[level_id] = true
	# save_progress()

func is_level_beaten(level_id: String) -> bool: 
	return level_beaten.get(level_id, false)

func _NOT_USED_save_progress(): 
	var file = FileAccess.open(SAVE_FILENAME, FileAccess.WRITE)
	file.store_var(level_beaten)
	file.close()

func _NOT_USED_load_progress(): 
	if FileAccess.file_exists(SAVE_FILENAME): 
		var file = FileAccess.open(SAVE_FILENAME, FileAccess.READ)
		level_beaten = file.get_var()
		file.close()
