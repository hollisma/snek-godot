extends Node

enum VisualTheme { BASIC, SHADED }
var current_theme: VisualTheme = VisualTheme.BASIC

signal theme_changed(new_theme)

func toggle_theme(): 
	var new_theme = VisualTheme.SHADED if current_theme == VisualTheme.BASIC else VisualTheme.BASIC
	_set_theme(new_theme)

func _set_theme(new_theme: VisualTheme): 
	if current_theme == new_theme: 
		return
	current_theme = new_theme
	emit_signal("theme_changed", new_theme)
