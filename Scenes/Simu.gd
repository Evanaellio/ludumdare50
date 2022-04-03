extends Node

const POPU_INCREASE_PER_BUILDING_PER_TICK = 1

const CURRENCY_INCREASE_PER_POPU_PER_TICK = 2
const START_CURRENCY = 1000

const MONEY_TIMER_BASE = 1.0
const POPU_TIMER_BASE = 5.0

onready var water_exp = get_node("../WaterExpansion")

# Called when the node enters the scene tree for the first time.
func _ready():
	MapVariables.currency = START_CURRENCY
	
	$MoneyTimer.wait_time = MONEY_TIMER_BASE
	$PopuTimer.wait_time = POPU_TIMER_BASE

	get_node("../WaterExpansion").connect("water_placed", self, "on_water_placed")
	
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
		MapVariables.building.remove(found)
	update()

func update():
	var nbMaison = MapVariables.get_nb_enabled_building(BuildingSettings.BuildingID.House)
	var nbCityHall = MapVariables.get_nb_building(BuildingSettings.BuildingID.CityHall)
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

func update_timers(selected_sim_speed):
	var new_sim_speed_factor = SpeedSettings.SpeedFactor[selected_sim_speed]
	$MoneyTimer.wait_time = MONEY_TIMER_BASE / new_sim_speed_factor
	$PopuTimer.wait_time = POPU_TIMER_BASE / new_sim_speed_factor

func on_water_placed():
	for building in MapVariables.building:
		if building["type"] == BuildingSettings.BuildingID.CityHall:
			continue
		if building["type"] == BuildingSettings.BuildingID.Dam:
			continue

		if building["type"] == BuildingSettings.BuildingID.Bridge:
			if get_node("../WaterExpansion/TileMap").get_cellv(building["position"]) == 12:
				get_node("../BuildingsDisabled").set_cellv(building["position"], -1)
				continue

		var connected = water_exp.can_connect_city_hall(building["position"])
		building["enabled"] = connected
		if connected:
			get_node("../BuildingsDisabled").set_cellv(building["position"], -1)
		else:
			get_node("../BuildingsDisabled").set_cellv(building["position"], 0)
