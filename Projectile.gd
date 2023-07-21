extends Area2D

var SPEED: int = 1000
var velocity = Vector2.ZERO

func _ready():
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	await get_tree().create_timer(5).timeout
	queue_free()

func _process(delta):
	scale.y += 2 * delta
	scale.y = clamp(scale.y, 0, 10)

func _physics_process(delta):
	position += -transform.y * SPEED * delta
