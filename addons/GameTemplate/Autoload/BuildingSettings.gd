extends Node

enum BuildingID {
	NONE = -1,
	CityHall = 0,
	FakeDam = 1,
	House = 2,
	Pump = 3,
	Dam = 4,
}

var buildings_max_inhabitants = [
	5, #CityHall
	0, #FakeDam
	5, #House
	0, #Pump
	0, #Dam
]

var buildings_max_employees = [
	0, #CityHall
	0, #FakeDam
	0, #House
	1, #Pump
	0, #Dam
]

var buildings_cost = [
	0, #CityHall
	0, #FakeDam
	50, #House
	25, #Pump
	30, #Dam
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
