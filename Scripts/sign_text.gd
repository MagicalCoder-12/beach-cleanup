extends Node2D

@export var sign_text: String = ""
@export var font_size: int = 24
@export var text_color: Color = Color.WHITE
@export var bg_color: Color = Color(0, 0, 0, 0.7)

func _draw():
	var font = ThemeDB.get_project_theme().default_font
	if not font or sign_text.is_empty():
		return
	var size = font.get_string_size(sign_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var padding = Vector2(8, 6)
	draw_rect(Rect2(Vector2.ZERO - padding, size + padding * 2), bg_color)
	draw_string(font, Vector2.ZERO, sign_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, text_color)
