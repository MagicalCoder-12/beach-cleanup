extends CharacterBody2D

@export var speed: float = 120.0
@export var stun_duration: float = 2.0

var axe_scene: PackedScene = preload("res://Scenes/axe.tscn")
var axe_cooldown: float = 0.0
var stunned: bool = false
var stun_timer: float = 0.0

func _ready():
	$Area2D.body_entered.connect(_on_area_body_entered)

func _physics_process(delta):
	if stunned:
		stun_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		if stun_timer <= 0:
			stunned = false
			modulate = Color.WHITE
		return

	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		input_vector.y -= 1
	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	axe_cooldown -= delta

	if Input.is_action_just_pressed("Collect"):
		_collect_nearby()

func _unhandled_input(event):
	if stunned:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and axe_cooldown <= 0:
		_throw_axe()

func _collect_nearby():
	var collect_area = $Area2D
	if not collect_area:
		return
	for area in collect_area.get_overlapping_areas():
		if area.has_method("collect") and area.is_in_group("crabs"):
			area.collect()
			GameManager.crabs_collected += 1
			return
	for body in collect_area.get_overlapping_bodies():
		if body.is_in_group("ghosts") and body.has_method("collect"):
			if body.vulnerable:
				body.collect()
				GameManager.ghosts_collected += 1
			else:
				_stun()
			return

func _throw_axe():
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()

	var axe = axe_scene.instantiate()
	axe.global_position = global_position
	axe.direction = dir
	get_tree().current_scene.add_child(axe)

	axe_cooldown = 1.0

func _stun():
	if stunned:
		return
	stunned = true
	stun_timer = stun_duration
	modulate = Color(0.5, 0.5, 1.0, 1.0)

func _on_area_body_entered(body: Node2D):
	if body.is_in_group("ghosts") and body.has_method("hit") and not body.vulnerable:
		_stun()
