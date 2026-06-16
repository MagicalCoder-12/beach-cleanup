extends Area2D

@export var speed: float = 300.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)
	var timer := Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	timer.autostart = true
	add_child(timer)

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D):
	if body.has_method("stun"):
		body.stun()
	queue_free()
