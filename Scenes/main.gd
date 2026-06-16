extends Node

func _ready():
	GameManager.total_crabs = get_tree().get_nodes_in_group("crabs").size()
