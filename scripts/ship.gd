extends CharacterBody2D

const projectile_scene: PackedScene = preload("res://nodes/projectile.tscn")

const SPEED: int = 20

var momentum: Vector2 = Vector2.ZERO

var fire_rate: float = 0.75
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
	var y_direction: float = Input.get_axis("up", "down")
	
	if GUI.fuel > 0:
		if x_direction:
			momentum.x += x_direction * SPEED * delta
		else:
			momentum.x = move_toward(momentum.x, 0, SPEED * delta)
		
		if y_direction:
			momentum.y += y_direction * SPEED * delta
		else:
			momentum.y = move_toward(momentum.y, 0, SPEED * delta)
		
		if x_direction or y_direction:
			GUI.fuel -= 1
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		if collision.get_collider().is_in_group("environment"):
			var collision_normal: Vector2 = collision.get_normal()
			momentum -= collision_normal * 3
			velocity -= collision_normal * 3
			collision_normal = -abs(collision_normal)
			if collision_normal.x == 0:
				collision_normal.x = 0.5
			if collision_normal.y == 0:
				collision_normal.y = 0.5
			momentum *= 0.7 * collision_normal
			velocity *= 0.7 * collision_normal
			print(velocity)
	
	momentum.y = clamp(momentum.y, -10, 10)
	momentum.x = clamp(momentum.x, -10, 10)
	velocity.y = clamp(velocity.y, -500, 500)
	velocity.x = clamp(velocity.x, -500, 500)
	velocity += momentum
	momentum = momentum.move_toward(Vector2.ZERO, SPEED * 0.1 * delta)
	move_and_slide()
