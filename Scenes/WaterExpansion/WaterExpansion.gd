extends Node2D

onready var tilemap : TileMap = $TileMap

var rivers = []

enum Tile {
	GRASS = 11,
	BORDER = 9
}

func _ready():
	randomize()
	
	for x in range(0, 102):
		for y in range(0, 102):
			if x == 0 or x == 101 or y == 0 or y == 101:
				$TileMap.set_cell(x, y, Tile.BORDER)
			else:
				$TileMap.set_cell(x, y, Tile.GRASS)
	
	rivers.append(River.new(Vector2(56,26), tilemap))
	rivers.append(River.new(Vector2(38,18), tilemap))
	rivers.append(River.new(Vector2(39,36), tilemap))
	rivers.append(River.new(Vector2(75,37), tilemap))
	rivers.append(River.new(Vector2(78,14), tilemap))

func _on_Timer_timeout():
	for river in rivers:
		river.simulate_flow()
