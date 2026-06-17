extends CharacterBody2D

@export var move_speed: float = 100.0

var hit_count: int = 0
var vulnerable: bool = false
var _desired_velocity: Vector2
var _wander_timer: float = 0.0

func _ready():
	add_to_group("ghosts")

func _physics_process(delta):
	if vulnerable:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * delta * 4)
		move_and_slide()
		return

	_wander_timer -= delta
	if _wander_timer <= 0:
		var angle = randf_range(0, TAU)
		_desired_velocity = Vector2(cos(angle), sin(angle)) * move_speed
		_wander_timer = randf_range(0.3, 0.8)

	var oscillation = Vector2(
		sin(Time.get_ticks_msec() * 0.005 + global_position.y * 0.02),
		cos(Time.get_ticks_msec() * 0.005 + global_position.x * 0.02)
	) * 30

	velocity = velocity.move_toward(_desired_velocity + oscillation, move_speed * delta * 4)
	move_and_slide()

func hit():
	if vulnerable:
		return
	hit_count += 1
	if hit_count >= 2:
		vulnerable = true
		modulate.a = 0.4
		collision_layer = 0

func collect():
	queue_free()
