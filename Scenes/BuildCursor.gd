extends Node2D

var current_building = BuildingSettings.BuildingID.NONE
var collide = false

func _process(delta):
	if collide:
		modulate = Color("#ff7777")
	else:
		if MapVariables.currency > BuildingSettings.buildings_cost[current_building]:
			modulate = Color("#84ff77")
		else:
			modulate = Color("#ff7777")

func set_building(building_id):
	current_building = building_id

	var building_sprite = BuildingSettings.buildings_sprite[building_id]
	
	$TileMap.set_cell(0, 0, building_sprite)
	var texture = $TileMap.tile_set.tile_get_texture(building_sprite)
	
	$Collision/Shape.shape = $TileMap.tile_set.tile_get_shape(building_sprite, 0)
	$Collision/Shape.position = $TileMap.tile_set.tile_get_shape_offset(building_sprite, 0)

func set_build_position(local_pos):
	var building_sprite = BuildingSettings.buildings_sprite[current_building]

	var pos = local_pos
	if $TileMap.tile_set.tile_get_tile_mode(building_sprite) == 1:
		pos -= Vector2(16, 16)
	else:
		pos -= $TileMap.tile_set.tile_get_region(building_sprite).size / 2
		pos -= Vector2(8, 8)
	
	pos = Vector2(int(pos.x / 16+1), int(pos.y / 16)+1) * 16
	position = pos

func get_tile_position():
	return position / 16

func update_collision():
	var bodies = $Collision.get_overlapping_bodies()
	collide = bodies.size() > 1

func _on_Collision_body_entered(body):
	update_collision()

func _on_Collision_body_exited(body):
	update_collision()
