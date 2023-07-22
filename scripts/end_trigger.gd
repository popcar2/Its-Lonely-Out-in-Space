extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.can_control = false
		var camera = get_tree().get_first_node_in_group("camera")
		var tween: Tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "zoom", Vector2(0.25, 0.25), 5)
		await get_tree().create_timer(4).timeout
		GUI.end_game()
