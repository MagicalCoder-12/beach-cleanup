extends Node

@onready var gamestates: CanvasLayer = $Gamestates
@onready var game_won_window = $Gamestates/GameWonWindow
@onready var level_lost_window = $Gamestates/LevelLostWindow
@onready var pause_menu_layer: CanvasLayer = $PauseMenuLayer

func _ready():
	GameManager.total_crabs = get_tree().get_nodes_in_group("crabs").size()
	GameManager.total_ghosts = get_tree().get_nodes_in_group("ghosts").size()
	GameManager.game_won.connect(_on_game_won)
	GameManager.game_lost.connect(_on_game_lost)
	game_won_window.continue_pressed.connect(_on_game_won_continue)
	game_won_window.main_menu_pressed.connect(_on_window_main_menu)
	level_lost_window.restart_pressed.connect(_on_level_lost_restart)
	level_lost_window.main_menu_pressed.connect(_on_window_main_menu)

func _unhandled_input(event):
	if not GameManager.game_active:
		return
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		_toggle_pause()

func _toggle_pause():
	if pause_menu_layer.visible:
		pause_menu_layer.hide()
	else:
		pause_menu_layer.show()

var _transitioning: bool = false

func _on_game_won():
	gamestates.show()
	level_lost_window.hide()
	game_won_window.show()
	_transitioning = true
	await get_tree().create_timer(5.0, true).timeout
	if _transitioning:
		_go_to_end_credits()

func _on_game_lost():
	gamestates.show()
	game_won_window.hide()
	level_lost_window.show()

func _on_game_won_continue():
	if not _transitioning:
		return
	_transitioning = false
	_go_to_end_credits()

func _on_level_lost_restart():
	get_tree().reload_current_scene()

func _on_window_main_menu():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu/main_menu.tscn")

func _go_to_end_credits():
	get_tree().change_scene_to_file("res://example/scenes/end_credits/end_credits.tscn")
