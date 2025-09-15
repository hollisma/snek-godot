extends Sprite2D

@export var basic_texture: Texture2D
@export var shaded_texture: Texture2D

func _ready(): 
	ThemeManager.theme_changed.connect(_on_theme_changed)
	_on_theme_changed(ThemeManager.current_theme)

func _on_theme_changed(new_theme): 
	texture = shaded_texture if new_theme == ThemeManager.VisualTheme.SHADED else basic_texture
