extends Node

var total_crabs: int = 0
var total_ghosts: int = 0

var crabs_collected: int = 0:
	set(value):
		crabs_collected = value
		crabs_changed.emit(crabs_collected)
		_check_win()

var ghosts_collected: int = 0:
	set(value):
		ghosts_collected = value
		ghosts_changed.emit(ghosts_collected)
		_check_win()

var game_time_remaining: float = 180.0
var game_active: bool = true

signal crabs_changed(count: int)
signal ghosts_changed(count: int)
signal game_won
signal game_lost
signal time_updated(time: float)

var music: AudioStreamPlayer

func _ready():
	music = AudioStreamPlayer.new()
	music.stream = load("res://assets/661248__magmadiverrr__video-game-menu-music.mp3")
	music.autoplay = true
	music.finished.connect(music.play)
	add_child(music)

func _process(delta):
	if not game_active:
		return
	game_time_remaining -= delta
	time_updated.emit(game_time_remaining)
	if game_time_remaining <= 0:
		game_time_remaining = 0
		game_lost.emit()
		game_active = false

func _check_win():
	if crabs_collected >= total_crabs and ghosts_collected >= total_ghosts:
		game_won.emit()
		game_active = false
