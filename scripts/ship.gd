extends CharacterBody2D

@onready var ship_smoke: GPUParticles2D = $"Ship Smoke"

signal player_died()

const projectile_scene: PackedScene = preload("res://nodes/projectile.tscn")
const explosion_particle_scene: PackedScene = preload("res://particles/explosion_particles.tscn")
const SPEED: int = 20

var momentum: Vector2 = Vector2.ZERO
var respawn_point: Vector2

var fire_rate: float = 0.75
var is_shooting: bool = false
var can_shoot: bool = true
var can_get_hit: bool = true
var is_dead: bool = false
var is_restarting: bool = false

func _ready():
	#ship_smoke.rotation_degrees = 90
	ship_smoke.emitting = false
	ship_smoke.modulate = Color(2, 2, 2)
	respawn_point = global_position

func _process(_delta):
	if is_dead:
		return
	
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	rotation_degrees += 90
	
	if Input.is_action_pressed("attack") and can_shoot and GUI.fuel > 0:
		shoot_cooldown()
		var projectile: Area2D = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.rotation_degrees += 90
		add_sibling(projectile)
		GUI.fuel -= 10
	
	if Input.is_action_just_pressed("restart") and not is_restarting:
		restart()

func shoot_cooldown():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _physics_process(delta):
	if is_dead:
		return
	
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	
	if GUI.fuel > 0:
		emit_smoke(x_direction, y_direction)
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
	else:
		ship_smoke.emitting = false
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		if collision.get_collider().is_in_group("environment") and can_get_hit:
			can_get_hit_cooldown()
			var collision_normal: Vector2 = collision.get_normal()
			#momentum -= collision_normal * 2
			velocity -= collision_normal * 100
			collision_normal = -abs(collision_normal)
			if collision_normal.x == 0:
				collision_normal.x = 0.5
			if collision_normal.y == 0:
				collision_normal.y = 0.5
			momentum *= 0.7 * collision_normal
			velocity *= 0.7 * collision_normal
			velocity.y = clamp(velocity.y, -300, 300)
			velocity.x = clamp(velocity.x, -300, 300)
			GUI.hp -= 20
			check_death()
			print(velocity)
	
	momentum.y = clamp(momentum.y, -10, 10)
	momentum.x = clamp(momentum.x, -10, 10)
	velocity.y = clamp(velocity.y, -500, 500)
	velocity.x = clamp(velocity.x, -500, 500)
	velocity += momentum
	momentum = momentum.move_toward(Vector2.ZERO, SPEED * 0.2 * delta)
	move_and_slide()

func can_get_hit_cooldown():
	can_get_hit = false
	await get_tree().create_timer(0.1).timeout
	can_get_hit = true

func emit_smoke(x_direction: float, y_direction: float):
	# Who even needs optimized code
	if x_direction == 0 and y_direction > 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(0, -50)
		ship_smoke.rotation_degrees = 270
	elif x_direction > 0 and y_direction > 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(-50, -50)
		ship_smoke.rotation_degrees = 225
	elif x_direction > 0 and y_direction == 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(-50, 0)
		ship_smoke.rotation_degrees = 180
	elif x_direction > 0 and y_direction < 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(-50, 50)
		ship_smoke.rotation_degrees = 135
	elif x_direction == 0 and y_direction < 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(0, 50)
		ship_smoke.rotation_degrees = 90
	elif x_direction < 0 and y_direction < 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(50, 50)
		ship_smoke.rotation_degrees = 45
	elif x_direction < 0 and y_direction == 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(50, 0)
		ship_smoke.rotation_degrees = 0
	elif x_direction < 0 and y_direction > 0:
		ship_smoke.emitting = true
		ship_smoke.global_position = global_position + Vector2(50, -50)
		ship_smoke.rotation_degrees = -45
	else:
		ship_smoke.emitting = false

func check_death():
	if GUI.hp <= 0:
		die()

func die():
	is_dead = true
	$Sprite2D.hide()
	spawn_explosion_particles()
	player_died.emit()
	await get_tree().create_timer(1).timeout
	respawn()

func restart():
	is_restarting = true
	await get_tree().create_timer(0.75).timeout
	if Input.is_action_pressed("restart") and not is_dead:
		die()
	is_restarting = false

func spawn_explosion_particles():
	var explosion_particles: Node2D = explosion_particle_scene.instantiate()
	for particle in explosion_particles.get_children():
		particle.emitting = true
	explosion_particles.global_position = global_position
	add_sibling(explosion_particles)
	await get_tree().create_timer(2).timeout
	explosion_particles.queue_free()

func respawn():
	velocity = Vector2.ZERO
	momentum = Vector2.ZERO
	ship_smoke.emitting = false
	
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property(get_tree().get_first_node_in_group("camera"), "global_position", respawn_point, 2).finished
	global_position = respawn_point
	spawn_explosion_particles()
	
	await get_tree().create_timer(0.3).timeout
	GUI.fuel = GUI.max_fuel
	GUI.hp = GUI.max_hp
	$Sprite2D.show()
	is_dead = false
