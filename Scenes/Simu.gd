extends Node

const POPU_INCREASE_PER_BUILDING_PER_TICK = 1

const CURRENCY_INCREASE_PER_POPU_PER_TICK = 2
const START_CURRENCY = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	MapVariables.currency = START_CURRENCY
	update()

func _on_MoneyTimer_timeout():
	MapVariables.currency += MapVariables.currency_change
	update()

func _on_PopuTimer_timeout():
	if MapVariables.population < MapVariables.max_population:
		MapVariables.population += MapVariables.population_change
		update()

func add_building(building_id, position):
	MapVariables.building.append({
		"type": building_id,
		"position": position,
		"enabled": true
	})
	MapVariables.currency -= BuildingSettings.buildings_cost[building_id]
	update()

func remove_building(position):
	var found = -1
	for id in range(0, MapVariables.building.size()):
		if MapVariables.building[id]['position'] == position:
			found = id
	if found > -1:
		MapVariables.building.erase(found)
	update()

func update():
	var nbMaison = get_nb_building(BuildingSettings.BuildingID.House)
	var nbCityHall = get_nb_building(BuildingSettings.BuildingID.CityHall)
	var popu = (nbMaison + nbCityHall) * POPU_INCREASE_PER_BUILDING_PER_TICK
	MapVariables.population_change = popu
	MapVariables.max_population = nbMaison * BuildingSettings.buildings_max_inhabitants[BuildingSettings.BuildingID.House]
	MapVariables.max_population += nbCityHall * BuildingSettings.buildings_max_inhabitants[BuildingSettings.BuildingID.CityHall]
	
	if MapVariables.population > MapVariables.max_population:
		MapVariables.population = MapVariables.max_population
	
	if MapVariables.population == MapVariables.max_population:
		MapVariables.population_change = 0

	var currency = MapVariables.population * CURRENCY_INCREASE_PER_POPU_PER_TICK
	MapVariables.currency_change = currency

	MapVariables.update()

func get_nb_building(type):
	var count = 0
	for item in MapVariables.building:
		if item['type'] == type:
			count += 1
	return count

func get_nb_enabled_building(type):
	var count = 0
	for item in MapVariables.building:
		if item['type'] == type and item['enabled'] == true:
			count += 1
	return count
