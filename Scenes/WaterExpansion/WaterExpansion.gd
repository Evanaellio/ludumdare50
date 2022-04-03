extends Node2D

export var X_SIZE = 100
export var Y_SIZE = 100
export var NB_RIVERS = 3

onready var tilemap : TileMap = $TileMap

var growing_rivers = []
var still_rivers = []

enum Tile {
	GRASS = 11,
	BORDER = 9
}

const TIMER_BASE = 0.5

func _ready():
	$Timer.wait_time = TIMER_BASE
	
	X_SIZE = MapVariables.x_size
	Y_SIZE = MapVariables.y_size
	seed(MapVariables.map_seed.hash())
	
	for x in range(0, X_SIZE + 2):
		for y in range(0, Y_SIZE + 2):
			if x == 0 or x == X_SIZE + 1 or y == 0 or y == Y_SIZE + 1:
				$TileMap.set_cell(x, y, Tile.BORDER)
			else:
				$TileMap.set_cell(x, y, Tile.GRASS)
	for x in range (0, NB_RIVERS):
		add_river()
	

func _on_Timer_timeout():
	for river in growing_rivers:
		river.simulate_flow()
		if river.stopped :
			remove_river(growing_rivers.find(river))
			add_river()
			

func remove_river(index):
	still_rivers.append(growing_rivers[index])
	growing_rivers.remove(index)
	

func add_river():
	var river = preload("res://Scenes/WaterExpansion/River.tscn").instance()
	river.init(Vector2(randi() % X_SIZE, randi() % Y_SIZE), tilemap)
	$Rivers.add_child(river)
	growing_rivers.append(river)

func update_timers(selected_sim_speed):
	var new_sim_speed_factor = SpeedSettings.SpeedFactor[selected_sim_speed]
	$Timer.wait_time = TIMER_BASE / new_sim_speed_factor
