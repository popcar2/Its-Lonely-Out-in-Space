extends Line2D

@onready var checkpoint_SFX: AudioStreamPlayer2D = $checkpointSFX

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GUI.hp = GUI.max_hp
		GUI.fuel = GUI.max_fuel
		body.respawn_point = global_position
		GUI._on_player_died()
		
		var tween: Tween = get_tree().create_tween()
		default_color = Color.LAWN_GREEN
		tween.tween_property(self, "default_color", Color("00d7e7"), 1)
		
		for barrier in get_tree().get_nodes_in_group("barrier"):
			barrier.renew_barrier()
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.respawn_enemy()
		
		checkpoint_SFX.play()
