extends Area2D

enum ENEMY_TYPE_ENUM{MINE, CHASER}
@export var enemy_type: ENEMY_TYPE_ENUM
@export var hp: int = 10 : 
	set(value):
		hp = value
		if hp <= 0:
			destroy_enemy()

@export var explosion_dmg: int = 80
@export var speed: int = 500

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var explosion_SFX: AudioStreamPlayer2D = $ExplosionSFX

var explosion_particle_scene: PackedScene = preload("res://particles/explosion_particles.tscn")

var max_hp: int

var respawn_point: Vector2
var default_collision_scale: Vector2
var damaged_player: bool = false
var player: Node2D
var is_chasing: bool = false

func _ready():
	respawn_point = global_position
	default_collision_scale = collision_shape.scale
	max_hp = hp
	player = get_tree().get_first_node_in_group("player")
	player.player_died.connect(stop_chasing)

func _physics_process(_delta):
	if is_chasing:
		look_at(player.global_position)
		rotation_degrees += 90
		global_position = global_position.move_toward(player.position, speed)
		

func stop_chasing():
	is_chasing = false

func destroy_enemy():
	visible = false
	explosion_SFX.play()
	collision_shape.scale *= 2
	spawn_explosion_particles()
	if enemy_type == ENEMY_TYPE_ENUM.MINE:
		await get_tree().create_timer(0.5).timeout
	else:
		await get_tree().create_timer(0.15).timeout
	collision_shape.set_deferred("disabled", true)

func respawn_enemy():
	await get_tree().create_timer(0.1).timeout
	visible = true
	collision_shape.set_deferred("disabled", false)
	damaged_player = false
	collision_shape.scale = default_collision_scale
	hp = max_hp
	global_position = respawn_point
	stop_chasing()

func spawn_explosion_particles():
	var explosion_particles: Node2D = explosion_particle_scene.instantiate()
	for particle in explosion_particles.get_children():
		particle.emitting = true
	explosion_particles.global_position = global_position
	explosion_particles.modulate = Color(0.72587436437607, 0.22795641422272, 0.22763386368752)
	add_sibling(explosion_particles)
	await get_tree().create_timer(2).timeout
	explosion_particles.queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if visible:
			destroy_enemy()
		if not damaged_player:
			GUI.hp -= explosion_dmg
			damaged_player = true
			var collision_normal = Vector2(body.global_position.x - global_position.x, body.global_position.y - global_position.y)
			collision_normal = collision_normal.normalized()
			body.velocity += collision_normal * 1000

func _on_detection_radius_body_entered(body):
	if body.is_in_group("player"):
		is_chasing = true
