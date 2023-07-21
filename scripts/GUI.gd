extends CanvasLayer

@onready var fuel_progressbar: TextureProgressBar = $Control/FuelProgressBar
@onready var hp_progressbar: TextureProgressBar = $Control/HPProgressBar

var max_fuel: int = 500
var fuel: int = 500 :
	set(value):
		fuel = value
		fuel_progressbar.value = fuel

var max_hp: int = 100
var hp: int = 100 :
	set(value):
		hp = value
		tween_progressbar(hp_progressbar, hp, 0.5)

func _ready():
	fuel_progressbar.max_value = max_fuel
	fuel_progressbar.value = fuel
	hp_progressbar.max_value = max_hp
	hp_progressbar.value = hp

func tween_progressbar(progressbar: TextureProgressBar, value: int, time: float):
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(progressbar, "value", value, time)
