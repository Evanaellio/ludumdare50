extends Node

signal updated()

var currency = 0
var currency_change = 0

var max_population = 0
var population = 0
var population_change = 0

var water_stored = 0
var water_storage = 0

var next_water_rise_hours = 0

var x_size: int = 100
var y_size: int = 100

var map_seed = "ludumdare50"

# {
#   type: BuildingSettings.BuildingID
#   position: Vector2
#   enabled: bool
# }
var building = []

var inverse_build_map = {}

func _ready():
	pass # Replace with function body.
	
func update():
	emit_signal("updated")

func find_by_type(type):
	for item in building:
		if item['type'] == type:
			return item['position']
	return Vector2(-1, -1)

func get_nb_building(type):
	var count = 0
	for item in building:
		if item['type'] == type:
			count += 1
	return count

func get_nb_enabled_building(type):
	var count = 0
	for item in building:
		if item['type'] == type and item['enabled'] == true:
			count += 1
	return count
