extends CharacterBody2D

@export var move_speed: float = 50.0
@export var eat_range: float = 60.0

var target_crab: Area2D = null
var stunned: bool = false

func _ready():
	$Search.collision_mask = 1
	$Search.collision_layer = 4

func _physics_process(delta):
	if stunned:
		move_and_slide()
		return

	if not target_crab or not is_instance_valid(target_crab):
		target_crab = _find_nearest_crab()

	if target_crab:
		var direction = global_position.direction_to(target_crab.global_position)
		velocity = direction * move_speed
		move_and_slide()

		if global_position.distance_to(target_crab.global_position) < eat_range:
			_eat_crab(target_crab)
			target_crab = null
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func _find_nearest_crab() -> Area2D:
	var search_area = $Search
	var nearest: Area2D = null
	var nearest_dist = INF

	for area in search_area.get_overlapping_areas():
		if area.has_method("collect"):
			var dist = global_position.distance_squared_to(area.global_position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest = area
	return nearest

func _eat_crab(crab: Area2D):
	crab.collect()
	GameManager.crabs_eaten += 1

func stun(duration: float = 3.0):
	if stunned:
		return
	stunned = true
	velocity = Vector2.ZERO
	await get_tree().create_timer(duration).timeout
	stunned = false
