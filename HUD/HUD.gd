extends Control

onready var tracker = $Tracker


func _ready():
	$BuildMenu/BuildPanel/Housing/ItemList
	MapVariables.connect("updated", self, "updateUI")

func updateUI():
	tracker.updateUI()
