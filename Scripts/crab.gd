extends CharacterBody2D

@export var move_speed: float = 50.0

var collected: bool = false
var _desired_velocity: Vector2
var _wander_timer: float = 0.0

func _ready():
	add_to_group("crabs")

func _physics_process(delta):
	if collected:
		return

	_wander_timer -= delta
	if _wander_timer <= 0:
		var angle = randf_range(0, TAU)
		_desired_velocity = Vector2(cos(angle), sin(angle)) * move_speed
		_wander_timer = randf_range(0.3, 1.0)

	var oscillation = Vector2(
		sin(Time.get_ticks_msec() * 0.004 + global_position.y * 0.015),
		cos(Time.get_ticks_msec() * 0.004 + global_position.x * 0.015)
	) * 20

	velocity = velocity.move_toward(_desired_velocity + oscillation, move_speed * delta * 3)
	move_and_slide()

func collect():
	collected = true
	queue_free()
