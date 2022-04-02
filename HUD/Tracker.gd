extends Control

onready var currency = $Data/Currency
onready var population = $Data/Population
onready var water_storage = $Data/WaterStorage

onready var next_water_tick = $WaterRise/Time

onready var survived_time = $Survived/Time


func _ready():
	pass

func updateUI():
	currency.updateUI()
	population.updateUI()
	water_storage.updateUI()
