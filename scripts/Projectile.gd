extends Area2D

@export var damage: int = 10

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
		position += -transform.y * SPEED * 0.5 * delta

func _on_body_entered(body):
	destroy_projectile()
	if body.is_in_group("destructable"):
		body.hp -= damage

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		if area.hp > 0:
			destroy_projectile()
			area.hp -= damage

func destroy_projectile():
	is_alive = false
	var particles: GPUParticles2D = hit_particles.instantiate()
	particles.global_position = $ParticleSpawnPoint.global_position
	particles.emitting = true
	particles.rotation_degrees = rotation_degrees + 90
	add_sibling(particles)
	await get_tree().create_timer(1).timeout
	queue_free()
