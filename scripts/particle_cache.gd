extends Node2D

func _ready():
	$"Explosion Particles/Circle Explosion".emitting = true
	$"Explosion Particles/Star Explosion".emitting = true
	$"Powerup Particles".emitting = true
	$GPUParticles2D.emitting = true
	$"Ship Smoke".emitting = true
	
	await get_tree().create_timer(1).timeout
	queue_free()
