extends Control


onready var population = $HBoxContainer/Current
onready var population_change = $HBoxContainer/Expected


func _ready():
	pass

func updateUI():
	var current_population = MapVariables.population
	var max_population = MapVariables.max_population
	var current_population_change = MapVariables.population_change
	
	population.text = "%d / %d Population" % [current_population, max_population]
	
	if current_population_change > 0:
		population.text += " + %d" % current_population_change
