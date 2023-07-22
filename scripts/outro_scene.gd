extends Control

func _ready():
	if GUI.seconds_passed % 60 < 10:
		$"Time Val".text = "%d:0%d" % [GUI.seconds_passed / 60, GUI.seconds_passed % 60]
	else:
		$"Time Val".text = "%d:%d" % [GUI.seconds_passed / 60, GUI.seconds_passed % 60]
	$"Upgrades Val".text = "%d/10" % GUI.powerups_collected
	$"Deaths Val".text = str(GUI.deaths)
