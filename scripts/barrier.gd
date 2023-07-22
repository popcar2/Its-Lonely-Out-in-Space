extends StaticBody2D

@export var hp: int = 10 : 
	set(value):
		hp = value
		if hp <= 0:
			destroy_barrier()

@export var can_respawn: bool = true

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var break_SFX: AudioStreamPlayer2D = $BreakSFX

var recently_broken: bool = false

func destroy_barrier():
	visible = false
	collision_shape.set_deferred("disabled", true)
	break_SFX.pitch_scale = randf_range(0.8, 1.2)
	break_SFX.play()
	
	recently_broken = true
	await get_tree().create_timer(1).timeout
	recently_broken = false

func renew_barrier():
	if not recently_broken and can_respawn:
		visible = true
		collision_shape.set_deferred("disabled", false)
