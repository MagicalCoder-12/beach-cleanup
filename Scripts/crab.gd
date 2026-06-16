extends Area2D

@export var wander_radius: float = 10.0
@export var move_speed: float = 20.0

var initial_position: Vector2
var target_position: Vector2
var collected: bool = false

func _ready():
	initial_position = global_position
	target_position = initial_position
	_pick_new_target()

	var timer := Timer.new()
	timer.wait_time = 2.0
	timer.timeout.connect(_pick_new_target)
	timer.autostart = true
	add_child(timer)

func _pick_new_target():
	var offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	target_position = initial_position + offset

func _physics_process(delta):
	if collected:
		return
	global_position = global_position.move_toward(target_position, move_speed * delta)

func collect():
	collected = true
	queue_free()
