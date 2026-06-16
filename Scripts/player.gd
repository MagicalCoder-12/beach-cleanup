extends CharacterBody2D

@export var speed: float = 120.0

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

	if Input.is_action_just_pressed("Collect"):
		_collect_nearby_crab()

func _collect_nearby_crab():
	var collect_area = $Area2D
	if not collect_area:
		return
	for area in collect_area.get_overlapping_areas():
		if area.has_method("collect"):
			area.collect()
			GameManager.crabs_collected += 1
			break
