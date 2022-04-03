class_name River
extends Node2D

var starting_point: Vector2
var tilemap: TileMap
var river_id: int

var segments = []
var stopped = false
var DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]

enum Tile {
	WATER = 12,
	PREDICTED_WATER = 2,
	GRASS = 11,
	SOURCE = 8,
	BORDER = 9,
}

enum Building_Tiles {
	NONE = -1,
	CityHall = 0,
	House = 2,
	Pump = 3,
	Dam = 4,
}


var current_direction = DIRECTIONS[randi() % DIRECTIONS.size()]
var straight_count = 2

# Poor man's weighted random
var straight_weights = [
	1,
	2,2,2,
	3,3,3,
	4,
]

var direction_weights = {
	Vector2.UP : [0,0,0],
	Vector2.DOWN : [1,1,1],
	Vector2.RIGHT : [2,2,2],
	Vector2.LEFT : [3,3,3],
}

func init(p_starting_point: Vector2, p_tilemap: TileMap):
	starting_point = p_starting_point
	tilemap = p_tilemap
	get_instance_id()
	add_segment(starting_point, current_direction, Tile.SOURCE)
	

func add_segment(position: Vector2, direction: Vector2, tile = Tile.WATER):
	var new_segment = position + direction
	if tilemap.get_cellv(new_segment) == Tile.BORDER:
		stopped = true;
	else:
		tilemap.set_cellv(new_segment, tile)
	tilemap.update_bitmask_region(new_segment)
	segments.append(new_segment)
	$Collider.position = (new_segment * 16 + Vector2(8, 8))

func simulate_flow():
	if stopped:
		return

	var available_directions = []
	for direction in DIRECTIONS:
		if can_go_in_direction(segments[-1], direction):
			available_directions.append(direction)

	#if current_direction in available_directions and straight_count > 0:
	#	straight_count -= 1
	if len(available_directions) == 0:
		#push through for now
		current_direction = current_direction
		#stopped = true
	elif len(available_directions) == 1:
		#straight_count = straight_weights[randi() % straight_weights.size()]
		current_direction = available_directions[0]
		direction_weights[current_direction].append(DIRECTIONS.find(current_direction))
	else:
		#straight_count = straight_weights[randi() % straight_weights.size()]
		var weights = []
		for direction in available_directions:
			weights.append_array(direction_weights[direction])
		var choosed_dir_index = weights[randi() % weights.size()]
		current_direction = DIRECTIONS[choosed_dir_index]
		direction_weights[current_direction].append(choosed_dir_index)
	add_segment(segments[-1], current_direction)

func can_go_in_direction(segment: Vector2, direction: Vector2) -> bool:
		var next_segment = segment + direction
		# If the segment in two moves is already part of the current river, then the segments should not touch
		for dir in DIRECTIONS:
			if (-direction) != dir:
				var after_next_segment = segment + direction + dir
				if tilemap.get_cellv(after_next_segment) == Tile.WATER and segments.has(after_next_segment):
					return false
		
		return (tilemap.get_cellv(next_segment) == Tile.GRASS || 
			tilemap.get_cellv(next_segment) == Tile.BORDER)


func _on_river_collider_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var bodies = $Collider.get_overlapping_bodies()
	if(bodies.size() > 1):
		for b in bodies:
			if b.name == "Buildings":
				var gameview = get_node("../../../..")
				if gameview != null and gameview.has_method("destroy_building"):
					gameview.destroy_building(segments[-1])
				#var tilemap = get_node("../../../Buildings")
				#var building = tilemap.get_cellv(segments[-1])
