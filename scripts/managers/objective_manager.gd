extends Node

enum ConditionType { SCORE, SPEED, LENGTH }
enum Comparator { OVER, UNDER } # OVER is >= THRESHOLD, UNDER is < THRESHOLD
enum Outcome { WIN, LOSE }

signal objectives_completed(outcome: Outcome)
signal condition_updated(con_type: ConditionType, current: int, target: int)

var win_conditions: Array = [] # [ (ConditionType.SCORE, Comparator.OVER, 10), ... ]
var lose_conditions: Array = [] # [ (ConditionType.LENGTH, Comparator.UNDER, 3), ... ]
var outcome_emitted: bool = false

var progress = {} # { ConditionType.SCORE: 0, ConditionType.SPEED: 150, ... }


func apply_level_data(level_data: Dictionary): 
	var win_list: Array = []
	var lose_list: Array = []
	
	for con_data in level_data.get("win_cons", []): 
		var con = _build_con_from_data(con_data)
		if con.size() > 0: 
			win_list.append(con)
	
	for con_data in level_data.get("lose_cons", []): 
		var con = _build_con_from_data(con_data)
		if con.size() > 0: 
			lose_list.append(con)
	
	win_conditions = win_list
	lose_conditions = lose_list
	progress.clear()
	outcome_emitted = false

func update_condition(condition_type: ConditionType, value: int): 
	if outcome_emitted: 
		return
	
	progress[condition_type] = value
	
	# Update others on progress
	for win_con in win_conditions: 
		if win_con[0] == condition_type: 
			condition_updated.emit(condition_type, value, win_con[2])
	
	# Check win / lose logic (lose first)
	for lose_con in lose_conditions: 
		var con_type = lose_con[0]
		if condition_type == con_type and _value_meets(lose_con, value): 
			objectives_completed.emit(Outcome.LOSE)
			outcome_emitted = true
	
	if _all_win_cons_met(): 
		objectives_completed.emit(Outcome.WIN)
		outcome_emitted = true

###############
### HELPERS ###
###############

func _all_win_cons_met() -> bool:
	if win_conditions.size() == 0: 
		return false
	
	for win_con in win_conditions: 
		var con_type = win_con[0]
		var value = progress.get(con_type, -1)
		if value == -1: 
			return false
		if not _value_meets(win_con, value): 
			return false
	return true

func _value_meets(con, value) -> bool: 
	var comparator: Comparator = con[1]
	var threshold: int = con[2]
	
	match comparator: 
		Comparator.OVER: 
			return value >= threshold
		Comparator.UNDER: 
			return value < threshold
	
	return false

#######################
### DATA CONVERTERS ###
#######################

func _build_con_from_data(con_data: Dictionary) -> Array: 
	if not con_data.has("con_type"): 
		push_error("Missing 'con_type' in condition: %s" % con_data)
		return []
	var con_type = _string_to_condition_type(con_data["con_type"])
	if con_type == null: 
		push_error("Invalid 'con_type' in condition: %s" % con_data)
		return []
	
	if not con_data.has("comparator"): 
		push_error("Missing 'comparator' in condition: %s" % con_data)
		return []
	var comparator = _string_to_comparator(con_data["comparator"])
	if comparator == null: 
		push_error("Invalid 'comparator' in condition: %s" % con_data)
		return []
	
	if not con_data.has("value") or typeof(con_data["value"]) != TYPE_INT:
		push_error("Invalid or missing 'value' in condition: %s" % con_data)
		return []
	var value = con_data["value"]
	
	return [con_type, comparator, value]

func _string_to_condition_type(s: String): 
	match s.to_lower(): 
		"score": return ConditionType.SCORE
		"speed": return ConditionType.SPEED
		"length": return ConditionType.LENGTH
		_: 
			push_error("Unknown condition type: %s" % s)
			return null

func _string_to_comparator(s: String): 
	match s.to_lower(): 
		"over": return Comparator.OVER
		"under": return Comparator.UNDER
		_: 
			push_error("Unknown comparator: %s" % s)
			return null
