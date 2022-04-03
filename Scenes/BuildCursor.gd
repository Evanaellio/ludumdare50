extends Node2D

var current_building = 0
var collide = false

func set_building(building_id):
	current_building = building_id
	
	$TileMap.set_cell(0, 0, building_id)
	var texture = $TileMap.tile_set.tile_get_texture(building_id)
	
	$Collision/Shape.shape = $TileMap.tile_set.tile_get_shape(building_id, 0)
	$Collision/Shape.position = $TileMap.tile_set.tile_get_shape_offset(building_id, 0)

func set_build_position(local_pos):
	var pos = local_pos
	if $TileMap.tile_set.tile_get_tile_mode(current_building) == 1:
		pos -= Vector2(16, 16)
	else:
		pos -= $TileMap.tile_set.tile_get_region(current_building).size / 2
		pos -= Vector2(8, 8)
	
	pos = Vector2(int(pos.x / 16+1), int(pos.y / 16)+1) * 16
	position = pos

func get_tile_position():
	return position / 16

func update_collision():
	var bodies = $Collision.get_overlapping_bodies()
	collide = bodies.size() > 1
	
	if collide:
		modulate = Color("#ff7777")
	else:
		modulate = Color("#84ff77")

func _on_Collision_body_entered(body):
	update_collision()

func _on_Collision_body_exited(body):
	update_collision()
