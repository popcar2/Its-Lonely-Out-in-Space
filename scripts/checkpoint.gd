extends Line2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GUI.hp = GUI.max_hp
		GUI.fuel = GUI.max_fuel
		body.respawn_point = global_position
		
		var tween: Tween = get_tree().create_tween()
		default_color = Color.LAWN_GREEN
		tween.tween_property(self, "default_color", Color("00d7e7"), 1)
