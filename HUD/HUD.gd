extends Control

onready var tracker = $Tracker


func _ready():
	MapVariables.connect("updated", self, "updateUI")
	Time.connect("current_hour_changed", self, "updateUI")
	updateUI()

func updateUI():
	tracker.updateUI()
