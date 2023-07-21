extends StaticBody2D

@export var hp: int = 10 : 
	set(value):
		hp = value
		if hp <= 0:
			destroy_barrier()

@onready var collision_shape = $CollisionShape2D

func destroy_barrier():
	visible = false
	collision_shape.set_deferred("disabled", true)

func renew_barrier():
	visible = true
	collision_shape.set_deferred("disabled", false)
