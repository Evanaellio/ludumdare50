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

var survived_hours = 0

# {
#   type: BuildingSettings.BuildingID
#   position: Vector2
#   enabled: bool
# }
var building = []

func _ready():
	pass # Replace with function body.
	
func update():
	emit_signal("updated")
