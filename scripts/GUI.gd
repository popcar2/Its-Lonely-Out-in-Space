extends CanvasLayer

@onready var fuel_progressbar: TextureProgressBar = $Control/FuelProgressBar
@onready var hp_progressbar: TextureProgressBar = $Control/HPProgressBar
@onready var restart_panel: Panel = $"Control/Restart Panel"

var max_fuel: int = 500 :
	set(value):
		fuel_progressbar.max_value = value
		fuel_progressbar.size.x = value/2
		max_fuel = value
		$Control/FakeFuelProgressBar.size.x = max_fuel/2
var fuel: int = 500 :
	set(value):
		fuel = value
		tween_progressbar(fuel_progressbar, fuel, 0.2)
		if fuel <= 0:
			out_of_fuel()

var max_hp: int = 100 :
	set(value):
		hp_progressbar.max_value = value
		hp_progressbar.size.x = value * 2.5
		max_hp = value
		$Control/FakeHPProgressBar.size.x = value * 2.5
var hp: int = 100 :
	set(value):
		hp = value
		tween_progressbar(hp_progressbar, hp, 0.5)

var player: CharacterBody2D
var restart_panel_tween: Tween

func _ready():
	fuel_progressbar.max_value = max_fuel
	fuel_progressbar.value = fuel
	hp_progressbar.max_value = max_hp
	hp_progressbar.value = hp
	player = get_tree().get_first_node_in_group("player")
	restart_panel.modulate.a = 0
	player.player_died.connect(_on_player_died)

func tween_progressbar(progressbar: TextureProgressBar, value: int, time: float):
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(progressbar, "value", value, time)

func out_of_fuel():
	if restart_panel_tween == null or not restart_panel_tween.is_valid():
		restart_panel_tween = get_tree().create_tween()
	else:
		restart_panel_tween.kill()
		restart_panel_tween = get_tree().create_tween()
	restart_panel_tween.set_trans(Tween.TRANS_SINE)
	restart_panel_tween.tween_property(restart_panel, "modulate:a", 1, 3)

func _on_player_died():
	if restart_panel_tween == null or not restart_panel_tween.is_valid():
		restart_panel_tween = get_tree().create_tween()
	else:
		restart_panel_tween.kill()
		restart_panel_tween = get_tree().create_tween()
	restart_panel_tween.tween_property(restart_panel, "modulate:a", 0, 0.1)
