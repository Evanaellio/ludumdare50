extends Control


onready var population = $HBoxContainer/Current
onready var population_change = $HBoxContainer/Expected


func _ready():
	pass

func updateUI():
	var current_population = MapVariables.population
	var current_population_change = MapVariables.population_change
	
	population.text = "%04d" % current_population
	population_change.text = str(current_population_change)
