extends CanvasLayer

@onready var label: Label = $Label
@onready var subtitle: Label = $SubtitleLabel

func _ready():
	GameManager.game_lost.connect(_on_game_lost)
	GameManager.game_won.connect(_on_game_won)
	hide()

func _on_game_lost():
	show()
	get_tree().paused = true
	label.text = "GAME OVER"
	subtitle.text = "You ran out of time!"
	subtitle.show()

func _on_game_won():
	show()
	get_tree().paused = true
	label.text = "YOU WIN!"
	subtitle.text = "All crabs and ghost collected!"
	subtitle.show()

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu/main_menu.tscn")
