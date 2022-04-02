extends Node2D

onready var tilemap : TileMap = $TileMap

var rivers = []

func _ready():
	randomize()
	rivers.append(River.new(Vector2(56,26), tilemap))
	rivers.append(River.new(Vector2(38,18), tilemap))
	rivers.append(River.new(Vector2(39,36), tilemap))
	rivers.append(River.new(Vector2(75,37), tilemap))
	rivers.append(River.new(Vector2(78,14), tilemap))

func _on_Timer_timeout():
	for river in rivers:
		river.simulate_flow()
