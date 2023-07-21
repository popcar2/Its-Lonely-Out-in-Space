extends CanvasLayer

@onready var fuel_progressbar: TextureProgressBar = $Control/FuelProgressBar

var max_fuel: int = 500
var fuel: int = 500 :
	set(value):
		fuel = value
		fuel_progressbar.value = fuel

func _ready():
	fuel_progressbar.max_value = max_fuel
	fuel_progressbar.value = fuel
