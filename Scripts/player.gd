extends CharacterBody2D

@export var speed: float = 120.0

var axe_scene: PackedScene = preload("res://Scenes/axe.tscn")
var facing_direction: Vector2 = Vector2.RIGHT

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		facing_direction = input_vector

	velocity = input_vector * speed
	move_and_slide()

	if Input.is_action_just_pressed("Collect"):
		_collect_nearby_crab()

	if Input.is_action_just_pressed("attack"):
		_throw_axe()

func _collect_nearby_crab():
	var collect_area = $Area2D
	if not collect_area:
		return
	for area in collect_area.get_overlapping_areas():
		if area.has_method("collect"):
			area.collect()
			GameManager.crabs_collected += 1
			break

func _throw_axe():
	var axe = axe_scene.instantiate()
	axe.global_position = global_position
	axe.direction = facing_direction
	get_tree().current_scene.add_child(axe)
