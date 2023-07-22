extends Area2D

@export var is_hp_powerup: bool
@onready var powerup_SFX: AudioStreamPlayer2D = $PowerupSFX
var powerup_particles: PackedScene = preload("res://particles/powerup_particles.tscn")

func _physics_process(_delta):
	rotation_degrees += 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		powerup_SFX.play()
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		GUI.powerups_collected += 1
		if is_hp_powerup:
			GUI.max_hp += 10
			GUI.hp = GUI.max_hp
		else:
			GUI.max_fuel += 50
			GUI.fuel = GUI.max_fuel
			GUI.reset_restart_panel()
		var particles: GPUParticles2D = powerup_particles.instantiate()
		particles.modulate = modulate
		particles.global_position = global_position
		particles.emitting = true
		add_sibling(particles)
		await get_tree().create_timer(1).timeout
		queue_free()
