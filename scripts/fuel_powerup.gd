extends Area2D

var powerup_particles: PackedScene = preload("res://particles/powerup_particles.tscn")

func _physics_process(_delta):
	rotation_degrees += 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		GUI.max_fuel += 50
		GUI.fuel = GUI.max_fuel
		var particles: GPUParticles2D = powerup_particles.instantiate()
		particles.modulate = modulate
		particles.global_position = global_position
		particles.emitting = true
		add_sibling(particles)
		queue_free()
