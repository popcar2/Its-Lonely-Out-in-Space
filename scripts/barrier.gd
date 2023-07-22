extends StaticBody2D

@export var hp: int = 10 : 
	set(value):
		hp = value
		if hp <= 0:
			destroy_barrier()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var break_SFX: AudioStreamPlayer2D = $BreakSFX

func destroy_barrier():
	visible = false
	collision_shape.set_deferred("disabled", true)
	break_SFX.pitch_scale = randf_range(0.8, 1.2)
	break_SFX.play()

func renew_barrier():
	visible = true
	collision_shape.set_deferred("disabled", false)
