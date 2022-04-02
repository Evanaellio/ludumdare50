extends Node2D

var current_building = 0

func set_building(building_id):
	current_building = building_id

	$TileMap.set_cell(0, 0, building_id)
	var texture = $TileMap.tile_set.tile_get_texture(building_id)
	
	$Collision/Shape.shape = $TileMap.tile_set.tile_get_shape(building_id, 0)
	$Collision/Shape.position = $TileMap.tile_set.tile_get_shape_offset(building_id, 0)

func set_build_position(local_pos):
	local_pos -= $TileMap.tile_set.tile_get_texture(current_building).get_size() / 2 - Vector2(8, 8)
	local_pos = Vector2(int(local_pos.x / 16), int(local_pos.y / 16)) * 16
	position = local_pos

func update_collision():
	var bodies = $Collision.get_overlapping_bodies()
	var collide = bodies.size() > 1
	
	if collide:
		modulate = Color("#ff7777")
	else:
		modulate = Color("#84ff77")

func _on_Collision_body_entered(body):
	update_collision()

func _on_Collision_body_exited(body):
	update_collision()
