extends Control

func _ready():
	$"Time Val".text = "%d:%d" % [GUI.seconds_passed / 60, GUI.seconds_passed % 60]
	$"Upgrades Val".text = "%d/10" % GUI.powerups_collected
	$"Deaths Val".text = str(GUI.deaths)
