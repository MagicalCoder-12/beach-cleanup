extends CanvasLayer

@onready var label: Label = $Label

func _ready():
	GameManager.crabs_changed.connect(_on_crabs_changed)

func _on_crabs_changed(count: int):
	label.text = "Crabs: " + str(count)
