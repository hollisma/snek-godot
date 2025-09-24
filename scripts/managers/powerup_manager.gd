extends Node2D

@export var powerup_scenes: Array[PackedScene]

var spawn_time_min = GameConsts.POWERUP_SPAWN_TIME_MIN_SECONDS
var spawn_time_max = GameConsts.POWERUP_SPAWN_TIME_MAX_SECONDS

@onready var powerup_spawner = $PowerupSpawner
var snek: Node
var snek_head: Node

var powerup_freq_table: Array = []
var total_freq: int = 0

# Optional per-level overrides for powerup fade
var fade_delay_override: float = -1.0
var fade_duration_override: float = -1.0

func _ready(): 
	_apply_default_frequencies()

func _apply_default_frequencies(): 
	total_freq = 0
	powerup_freq_table.clear()
	for scene in powerup_scenes: 
		var temp = scene.instantiate()
		var freq = temp.FREQUENCY if "FREQUENCY" in temp else 1
		temp.queue_free()
		total_freq += freq
		powerup_freq_table.append({ "scene": scene, "cumulative": total_freq })

func apply_level_data(level_data): 
	if not level_data.has("powerups"): 
		return
	
	var freqs = level_data["powerups"]
	total_freq = 0
	powerup_freq_table.clear()
	
	# Apply frequencies
	for scene in powerup_scenes: 
		var key_name = _get_powerup_key(scene)
		var freq = int(freqs.get(key_name, 0)) # default 0 if powerup not in data
		total_freq += freq
		powerup_freq_table.append({ "scene": scene, "cumulative": total_freq })
	
	# Apply spawner timings
	if level_data.has("powerup_spawn"): 
		var spawn_cfg = level_data["powerup_spawn"]
		if spawn_cfg.has("min"): 
			spawn_time_min = int(spawn_cfg["min"]) 
		if spawn_cfg.has("max"): 
			spawn_time_max = int(spawn_cfg["max"])
	
	# Apply powerup fade overrides
	fade_delay_override = -1.0
	fade_duration_override = -1.0
	if level_data.has("powerup_fade"): 
		var fade_cfg = level_data["powerup_fade"]
		if fade_cfg.has("delay"): 
			fade_delay_override = float(fade_cfg["delay"]) 
		if fade_cfg.has("duration"): 
			fade_duration_override = float(fade_cfg["duration"]) 

func start_spawning(): 
	_restart_timer()

func stop(): 
	powerup_spawner.stop()

func spawn_powerup(): 
	if powerup_scenes.size() == 0: 
		return
	
	var scene = _pick_powerup()
	var powerup = scene.instantiate()
	powerup.global_position = _get_spawn_location()
	_apply_fade_to_powerup(powerup)
	
	call_deferred("add_child", powerup)
	powerup.collected.connect(_on_powerup_collected)

func _on_powerup_spawner_timeout():
	spawn_powerup()
	_restart_timer()

func _restart_timer():
	var spawn_time = randi_range(spawn_time_min, spawn_time_max)
	powerup_spawner.start(spawn_time)

func _get_powerup_key(scene: PackedScene) -> String: 
	var filename = scene.resource_path.get_file()
	var basename = filename.get_basename()       # "speed_power"
	basename = basename.replace("_power", "")    # "speed"
	return basename

func _pick_powerup() -> PackedScene: 
	var roll = randi_range(1, total_freq)
	for entry in powerup_freq_table: 
		if roll <= entry.cumulative: 
			return entry.scene
	return powerup_scenes[0] # fallback

func _get_spawn_location(): 
	var margin = 32
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (get_viewport().size.x - 2 * margin) + margin
		var y = randf() * (get_viewport().size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		if snek_head.position.distance_to(pos) > margin * 2: 
			break
	return pos

func _apply_fade_to_powerup(powerup): 
	if fade_delay_override >= 0.0: 
		powerup.fade_delay_seconds = fade_delay_override
	if fade_duration_override >= 0.0: 
		powerup.fade_duration_seconds = fade_duration_override

func _on_powerup_collected(powerup): 
	if powerup.has_method("apply_effect"): 
		powerup.apply_effect()
	if powerup.has_method("apply_effect_to_snek") and snek != null: 
		powerup.apply_effect_to_snek(snek)
	powerup.queue_free()

func __test(num): 
	if num == 1: 
		print('changing spawn times to ', 'fast' if spawn_time_min > 1 else 'slow')
		spawn_time_min = 1 if spawn_time_min > 1 else 3
		spawn_time_max = 1 if spawn_time_max > 1 else 7
