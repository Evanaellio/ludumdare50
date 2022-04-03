extends Control

onready var tracker = $Tracker


func _ready():
	MapVariables.connect("updated", self, "updateUI")
	updateUI()

func updateUI():
	tracker.updateUI()
