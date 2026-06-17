extends CanvasLayer

@onready var crabs_label: Label = $Crabs
@onready var ghosts_label: Label = $Ghosts
@onready var timer_label: Label = $TimerLabel

func _ready():
	GameManager.crabs_changed.connect(_on_crabs_changed)
	GameManager.ghosts_changed.connect(_on_ghosts_changed)
	GameManager.time_updated.connect(_on_time_updated)
	GameManager.game_won.connect(_on_game_won)

func _on_crabs_changed(count: int):
	crabs_label.text = "Crabs: %d/%d" % [count, GameManager.total_crabs]

func _on_ghosts_changed(count: int):
	ghosts_label.show()
	ghosts_label.text = "Ghosts: %d/%d" % [count, GameManager.total_ghosts]

func _on_time_updated(time: float):
	var remaining = max(0, int(ceil(time)))
	timer_label.text = "Time: %d" % remaining

func _on_game_won():
	timer_label.text = "Time: 0"
	if GameManager.ghosts_collected > 0:
		ghosts_label.show()
		ghosts_label.text = "Ghosts: %d/%d" % [GameManager.ghosts_collected, GameManager.total_ghosts]
