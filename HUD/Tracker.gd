extends Control

onready var currency = $Data/Currency
onready var population = $Data/Population
onready var water_storage = $Data/WaterStorage

onready var next_water_rise_hours = $WaterRise/Time

onready var survived_hours = $Survived/Time

func _ready():
	pass

func updateUI():
	currency.updateUI()
	population.updateUI()
	water_storage.updateUI()

	next_water_rise_hours.text = "%d h" % MapVariables.next_water_rise_hours

	var time = int(Time.seconds_to_hours(Time.seconds_elapsed) - 6)

	var days = time / 24
	var hours = time % 24
	survived_hours.text = "%d days %02d h" % [days, hours]
