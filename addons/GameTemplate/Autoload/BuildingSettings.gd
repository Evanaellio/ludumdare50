extends Node

enum BuildingID {
	NONE = -1,
	CityHall = 0,
	House = 1,
	Pump = 2,
	Dam = 3,
	Bridge = 4,
}

var buildings_sprite = [
	0, #CityHall
	2, #House
	3, #Pump
	4, #Dam
	5, #Bridge
]

var buildings_max_inhabitants = [
	5, #CityHall
	5, #House
	0, #Pump
	0, #Dam
	0, #Bridge
]

var buildings_max_employees = [
	0, #CityHall
	0, #House
	1, #Pump
	0, #Dam
	0, #Bridge
]

var buildings_cost = [
	0, #CityHall
	50, #House
	25, #Pump
	30, #Dam
	10, #Bridge TODO
]

var buildings_size = [
	Vector2(4, 3), #CityHall
	Vector2(2, 2), #House
	Vector2(1, 1), #Pump
	Vector2(1, 1), #Dam
	Vector2(1, 1), #Bridge
]

func get_id_by_sprite(sprite):
	for id in BuildingID.values():
		if buildings_sprite[id] == sprite:
			return id
	return -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
