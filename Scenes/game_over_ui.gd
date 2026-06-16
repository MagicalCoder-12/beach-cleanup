extends CanvasLayer

func _ready():
	GameManager.game_over.connect(_on_game_over)
	hide()

func _on_game_over():
	show()
	get_tree().paused = true

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu/main_menu.tscn")
