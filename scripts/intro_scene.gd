extends Control

func _ready():
	GUI.get_child(0).modulate.a = 0
	await get_tree().create_timer(2).timeout
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	get_tree().get_first_node_in_group("player").is_dead = false
	tween.tween_property(GUI.get_child(0), "modulate:a", 1, 4)
	await tween.tween_property(self, "modulate:a", 0, 4).finished
	queue_free()
