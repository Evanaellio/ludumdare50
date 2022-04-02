extends Control

onready var tracker = $Tracker


func _ready():
	$BuildMenu/BuildPanel/Housing/ItemList
	#connect()
	pass

func updateUI():
	tracker.updateUI()
