extends Node

var total_crabs: int = 0

var crabs_collected: int = 0:
	set(value):
		crabs_collected = value
		crabs_changed.emit(crabs_collected)

var crabs_eaten: int = 0:
	set(value):
		crabs_eaten = value
		if crabs_eaten >= total_crabs:
			game_over.emit()

signal crabs_changed(count: int)
signal game_over
