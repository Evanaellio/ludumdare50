extends Node2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;

onready var tween = $Camera2D/Tween
onready var zoom_target = $Camera2D.zoom

onready var build_menu = $CanvasLayer/HUD/BuildMenu

var building_mode = -1

func _ready():
	build_menu.connect("on_building_selected", self, "enable_build_mode")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event: InputEvent):
	handle_camera(event)

func handle_camera(event: InputEvent):
	if event is InputEventMouseButton:
		if building_mode > -1 and event.button_index == BUTTON_LEFT:
			if event.pressed == false and !$World/BuildCursor.collide:
				place_building()

		elif event.button_index == BUTTON_LEFT or event.button_index == BUTTON_MIDDLE:
			#get_tree().set_input_as_handled();
			if event.is_pressed():
				_previousPosition = event.position;
				_moveCamera = true;
			else:
				_moveCamera = false;
				
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			disable_build_mode()

		if event.button_index == BUTTON_WHEEL_UP:
			zoom(zoom_target*0.9, event.position)

		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom(zoom_target/0.9, event.position)

	if event is InputEventMouseMotion:

		if building_mode > -1:
			$World/BuildCursor.set_building(building_mode)
			var pos = get_viewport().canvas_transform.affine_inverse().xform(event.position) - $World.position
			$World/BuildCursor.set_build_position(pos)
	
		if _moveCamera:
			get_tree().set_input_as_handled();
			$Camera2D.position += (_previousPosition - event.position) * $Camera2D.zoom;
			_previousPosition = event.position;

func zoom(new_zoom, cursor_position):
	var cam_pos = $Camera2D.position + (-0.5 * $Camera2D.get_viewport().size / 5 + cursor_position)*(zoom_target - new_zoom)

	zoom_target = new_zoom
	$Camera2D.zoom= zoom_target
	$Camera2D.position = cam_pos

	#tween.remove_all()
	#tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, zoom_target, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.interpolate_property($Camera2D, "position", $Camera2D.position, cam_pos, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.interpolate_property($Camera2D, "smoothing_speed", 100, 10, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()

func enable_build_mode(building_id):
	$World/BuildCursor.visible = true
	building_mode = building_id
	_moveCamera = false;
	
func disable_build_mode():
	$World/BuildCursor.visible = false
	building_mode = -1

func place_building():
	position = $World/BuildCursor.get_tile_position()
	$World/Buildings.set_cellv(position, building_mode)
	$World/Buildings.update_bitmask_region(position)
	disable_build_mode()
