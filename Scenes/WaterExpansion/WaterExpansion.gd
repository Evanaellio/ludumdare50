extends Node2D

export var X_SIZE = 100
export var Y_SIZE = 100
export var NB_RIVERS = 3

onready var tilemap : TileMap = $TileMap

signal water_placed

var growing_rivers = []
var still_rivers = []

enum Tile {
	GRASS = 11,
	BORDER = 9
}

const TIMER_BASE = 0.5

onready var astar_node = AStar.new()
const ASTAR_BRIDGE_OFFSET = 1000000

func _ready():
	$Timer.wait_time = TIMER_BASE
	
	X_SIZE = MapVariables.x_size
	Y_SIZE = MapVariables.y_size
	seed(MapVariables.map_seed.hash())
	
	var astar_points = []
	astar_node.reserve_space(X_SIZE*Y_SIZE)
	
	for x in range(0, X_SIZE + 2):
		for y in range(0, Y_SIZE + 2):
			if x == 0 or x == X_SIZE + 1 or y == 0 or y == Y_SIZE + 1:
				$TileMap.set_cell(x, y, Tile.BORDER)
			else:
				$TileMap.set_cell(x, y, Tile.GRASS)
				if x > 1 and y > 1 and x < X_SIZE and y < Y_SIZE:
					astar_points.append(Vector2(x, y))
					astar_node.add_point(astar_index(Vector2(x, y)), Vector3(x, y, 0.0))

	for x in range (0, NB_RIVERS):
		add_river()

	for point in astar_points:
		_astar_connect(point)

func _astar_connect(point, is_bridge = false):
	var points_relative = PoolVector2Array([
		point + Vector2.RIGHT,
		point + Vector2.LEFT,
		point + Vector2.DOWN,
		point + Vector2.UP,
	])
	var point_index = astar_index(point, is_bridge)
	for point_relative in points_relative:
		var point_relative_index = astar_index(point_relative, is_bridge)
		if not astar_node.has_point(point_index):
			continue
		if not astar_node.has_point(point_relative_index):
			continue
		astar_node.connect_points(point_index, point_relative_index, true)

func astar_index(point, is_bridge = false):
	if is_bridge:
		return point.x + X_SIZE * point.y + ASTAR_BRIDGE_OFFSET
	else:
		return point.x + X_SIZE * point.y

func remove_astar_point(point):
	if astar_node.has_point(astar_index(point)):
		astar_node.remove_point(astar_index(point))
	emit_signal("water_placed")

func add_bridge(point):
	if !astar_node.has_point(astar_index(point, true)):
		astar_node.add_point(astar_index(point, true), Vector3(point.x, point.y, 0.0))
		# connect between bridges
		_astar_connect(point, true)
		# connect to tile below (if grass)
		if astar_node.has_point(astar_index(point)):
			astar_node.connect_points(astar_index(point), astar_index(point, true), true)

	emit_signal("water_placed")

func can_connect_city_hall(from):
	if MapVariables.get_nb_building(BuildingSettings.BuildingID.CityHall) == 0:
		return false
	if not astar_node.has_point(astar_index(from)):
		return false
	var hall_pos = MapVariables.find_by_type(BuildingSettings.BuildingID.CityHall)
	if not astar_node.has_point(astar_index(hall_pos)):
		return false
	var path = astar_node.get_id_path(astar_index(hall_pos), astar_index(from))
	return path.size() > 0

func _on_Timer_timeout():
	for river in growing_rivers:
		river.simulate_flow()
		if river.stopped :
			remove_river(growing_rivers.find(river))
			add_river()
			

func remove_river(index):
	var river = growing_rivers[index]
	still_rivers.append(river)
	var anim_sprite = river.get_node("Source")
	var still_sprite = river.get_node("SourceStopped")
	var particules_handle = river.get_node("WaterParticules")
	if anim_sprite != null and still_sprite != null:
		anim_sprite.visible = false
		still_sprite.visible = true
		particules_handle.emitting = false
	growing_rivers.remove(index)
	

func add_river():
	var river = preload("res://Scenes/WaterExpansion/River.tscn").instance()
	river.init(Vector2(randi() % X_SIZE, randi() % Y_SIZE), tilemap, self)
	$Rivers.add_child(river)
	growing_rivers.append(river)

func update_timers(selected_sim_speed):
	var new_sim_speed_factor = SpeedSettings.SpeedFactor[selected_sim_speed]
	$Timer.wait_time = TIMER_BASE / new_sim_speed_factor
