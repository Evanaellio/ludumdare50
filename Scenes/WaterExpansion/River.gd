class_name River
extends Object

var starting_point: Vector2
var tilemap: TileMap
var river_id: int

var segments = []
var stopped = false
var DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]

enum Tile {
	WATER = 1,
	PREDICTED_WATER = 2,
	GRASS = 6,
	SOURCE = 8,
}


var current_direction = Vector2.DOWN
var straight_count = 2

# Poor man's weighted random
var straight_weights = [
	1,
	2,2,2,
	3,3,3,3,3,
	4,4,
	5,
]

func _init(p_starting_point: Vector2, p_tilemap: TileMap):
	starting_point = p_starting_point
	tilemap = p_tilemap
	get_instance_id()
	add_segment(starting_point, Tile.SOURCE)

func add_segment(segment: Vector2, tile = Tile.WATER):
	tilemap.set_cellv(segment, tile)
	segments.append(segment)

func simulate_flow():
	if stopped:
		return

	var available_directions = []
	for direction in DIRECTIONS:
		if can_go_in_direction(segments[-1], direction):
			available_directions.append(direction)

	print(available_directions)

	if current_direction in available_directions and straight_count > 0:
		add_segment(segments[-1] + current_direction)
		straight_count -= 1
	elif len(available_directions) == 0:
		stopped = true
		return
	else:
		straight_count = straight_weights[randi() % straight_weights.size()]
		current_direction = available_directions[randi() % available_directions.size()]

func can_go_in_direction(segment: Vector2, direction: Vector2) -> bool:
		var next_segment = segment + direction
		var after_next_segment = segment + direction * 2
		# If the segment in two moves is already part of the current river, then the segments should not touch
		if tilemap.get_cellv(after_next_segment) == Tile.WATER and segments.has(after_next_segment):
			return false
		
		return tilemap.get_cellv(next_segment) == Tile.GRASS
