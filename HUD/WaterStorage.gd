extends Control


onready var water_pg = $HBoxContainer/ProgressBar


func _ready():
	pass

func updateUI():
	water_pg.min_value = 0
	water_pg.value = MapVariables.water_stored
	water_pg.max_value = MapVariables.water_storage
