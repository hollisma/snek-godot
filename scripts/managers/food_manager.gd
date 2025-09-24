extends Node2D

@export var food_scenes: Array[PackedScene]

var appl_scene: PackedScene = preload(ResourcePaths.SCENES["appl"])
var appl_green_scene: PackedScene = preload(ResourcePaths.SCENES["appl_green"])
var appl_golden_scene: PackedScene = preload(ResourcePaths.SCENES["appl_golden"])

const GOLDEN_APPL_TIME = 5.0 # 5.0 secs

var snek_head: Node
var golden_appl: Node
@onready var screen_size = get_viewport().size
@onready var golden_appl_timer = $GoldenApplTimer

# Frequency table for food types (mirrors PowerupManager)
var food_freq_table: Array = []
var total_food_freq: int = 0

func _ready(): 
	_apply_default_frequencies()

func _apply_default_frequencies(): 
	var defaults = {
		"appl": 80,
		"appl green": 15,
		"appl golden": 5,
	}
	_set_food_frequencies(defaults)

func apply_level_data(level_data): 
	if not level_data.has("foods"): 
		_apply_default_frequencies()
		return
	var freqs: Dictionary = level_data["foods"]
	_set_food_frequencies(freqs)

func _set_food_frequencies(freqs: Dictionary): 
	total_food_freq = 0
	food_freq_table.clear()
	
	for scene in food_scenes: 
		var key_name = _get_food_key(scene)
		var weight = int(freqs.get(key_name, 0))
		total_food_freq += weight
		food_freq_table.append({ "scene": scene, "cumulative": total_food_freq })

func _get_food_key(scene: PackedScene) -> String: 
	var filename = scene.resource_path.get_file()
	var basename = filename.get_basename()      # e.g., "appl_golden"
	basename = basename.replace("_", " ")     # "appl golden"
	return basename

func spawn_appl(): 
	var margin = 16
	var max_attempts = 100 # to avoid infinite loop
	var pos = Vector2.ZERO
	
	for _i in range(max_attempts): 
		var x = randf() * (screen_size.x - 2 * margin) + margin
		var y = randf() * (screen_size.y - 2 * margin) + margin
		pos = Vector2(x, y)
		if snek_head.position.distance_to(pos) > margin * 2: 
			break
	
	var scene = _pick_food()
	var appl = scene.instantiate()
	appl.position = pos
	if scene == appl_golden_scene: 
		start_golden_appl(appl)
	call_deferred("add_child", appl)

func _pick_food() -> PackedScene:	
	var roll = randi_range(1, max(1, total_food_freq))
	for entry in food_freq_table: 
		if roll <= entry.cumulative: 
			return entry.scene
	return food_scenes[0]

func start_golden_appl(appl): 
	golden_appl = appl
	var tween = create_tween()
	tween.tween_property(appl, "modulate:a", 0.0, GOLDEN_APPL_TIME)
	golden_appl_timer.start(GOLDEN_APPL_TIME)

func _on_GoldenApplTimer_timeout():
	if golden_appl and is_instance_valid(golden_appl): 
		golden_appl.queue_free()
		golden_appl = null
		spawn_appl()
