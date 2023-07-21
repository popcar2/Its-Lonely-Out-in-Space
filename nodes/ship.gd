extends CharacterBody2D

const projectile_scene: PackedScene = preload("res://nodes/projectile.tscn")

const SPEED: int = 20

var momentum: Vector2 = Vector2.ZERO

var fire_rate: float = 0.5
var is_shooting: bool = false
var can_shoot: bool = true

func _process(_delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	rotation_degrees += 90
	
	if Input.is_action_pressed("attack") and can_shoot:
		shoot_cooldown()
		var projectile: Area2D = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.rotation_degrees += 90
		add_sibling(projectile)

func shoot_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _physics_process(delta):
	var x_direction: float = Input.get_axis("left", "right")
	if x_direction:
		momentum.x += x_direction * SPEED * delta
	else:
		momentum.x = move_toward(momentum.x, 0, SPEED * delta)
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		if collision.get_collider().is_in_group("environment"):
			print(collision.get_normal())
			momentum *= -0.3
			velocity *= -0.5
	
	var y_direction: float = Input.get_axis("up", "down")
	if y_direction:
		momentum.y += y_direction * SPEED * delta
	else:
		momentum.y = move_toward(momentum.y, 0, SPEED * delta)
	
	momentum.y = clamp(momentum.y, -10, 10)
	momentum.x = clamp(momentum.x, -10, 10)
	velocity.y = clamp(velocity.y, -500, 500)
	velocity.x = clamp(velocity.x, -500, 500)
	velocity += momentum
	move_and_slide()
