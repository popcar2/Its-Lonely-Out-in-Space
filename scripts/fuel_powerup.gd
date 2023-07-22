extends Area2D

@export var is_hp_powerup: bool
var powerup_particles: PackedScene = preload("res://particles/powerup_particles.tscn")

func _physics_process(_delta):
	rotation_degrees += 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		if is_hp_powerup:
			GUI.max_hp += 10
			GUI.hp = GUI.max_hp
		else:
			GUI.max_fuel += 50
			GUI.fuel = GUI.max_fuel
		var particles: GPUParticles2D = powerup_particles.instantiate()
		particles.modulate = modulate
		particles.global_position = global_position
		particles.emitting = true
		add_sibling(particles)
		queue_free()
