extends Node

enum BuildingID {
	NONE = -1,
	CityHall = 0,
	Dam = 1,
	House = 2,
	Pump = 3,
}

var buildings_max_inhabitants = [
	5, #CityHall
	0, #Dam
	5, #House
	0, #Pump
]

var buildings_max_employees = [
	0, #CityHall
	0, #Dam
	0, #House
	1, #Pump
]

var buildings_cost = [
	0, #CityHall
	30, #Dam
	50, #House
	25, #Pump
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
