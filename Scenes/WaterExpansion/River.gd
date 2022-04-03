class_name River
extends Object

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

func _init(p_starting_point: Vector2, p_tilemap: TileMap):
	starting_point = p_starting_point
	tilemap = p_tilemap
	get_instance_id()
	add_segment(starting_point, Tile.SOURCE)

func add_segment(segment: Vector2, tile = Tile.WATER):
	if tilemap.get_cellv(segment) == Tile.BORDER:
		stopped = true;
	else:
		tilemap.set_cellv(segment, tile)
	tilemap.update_bitmask_region(segment)
	segments.append(segment)

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
	add_segment(segments[-1] + current_direction)

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
