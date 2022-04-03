extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _on_MoneyTimer_timeout():
	MapVariables.currency += MapVariables.currency_change
	update()

func _on_PopuTimer_timeout():
	if MapVariables.population < MapVariables.max_population:
		MapVariables.population += MapVariables.population_change
		update()

func update():
	var currency = MapVariables.population * 2
	MapVariables.currency_change = currency
	
	var nbMaison = 0 #TODO
	var nbCityHall = 1 #TODO
	var popu = nbMaison * 1 + nbCityHall * 1
	MapVariables.population_change = popu
	MapVariables.max_population = nbMaison * 5 + nbCityHall * 10
	
	if MapVariables.population > MapVariables.max_population:
		MapVariables.population = MapVariables.max_population
	
	if MapVariables.population == MapVariables.max_population:
		MapVariables.population_change = 0

	MapVariables.update()
