extends Node

var crabs_collected: int = 0:
	set(value):
		crabs_collected = value
		crabs_changed.emit(crabs_collected)

signal crabs_changed(count: int)
