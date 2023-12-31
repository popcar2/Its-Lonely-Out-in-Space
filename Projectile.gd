extends Area2D

var SPEED: int = 1000
var velocity = Vector2.ZERO
var hit_particles: PackedScene = preload("res://particles/projectile_particles.tscn")

var is_alive: bool = true

func _ready():
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	await get_tree().create_timer(5).timeout
	queue_free()

func _process(delta):
	if is_alive:
		scale.y += 2 * delta
		scale.y = clamp(scale.y, 0, 10)
	else:
		scale.y -= 8 * delta
		scale.y = clamp(scale.y, 0, 10)

func _physics_process(delta):
	if is_alive:
		position += -transform.y * SPEED * delta
	else:
		position += -transform.y * SPEED * 0.8 * delta

func _on_body_entered(body):
	if body.is_in_group("environment"):
		is_alive = false
		var particles: GPUParticles2D = hit_particles.instantiate()
		particles.global_position = $ParticleSpawnPoint.global_position
		particles.emitting = true
		particles.rotation_degrees = rotation_degrees + 90
		add_sibling(particles)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body.shape)
