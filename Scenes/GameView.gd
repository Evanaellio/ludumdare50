extends Node2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event: InputEvent):
	handle_camera(event)

func handle_camera(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT or event.button_index == BUTTON_MIDDLE:
			get_tree().set_input_as_handled();
			if event.is_pressed():
				_previousPosition = event.position;
				_moveCamera = true;
			else:
				_moveCamera = false;

		if event.button_index == BUTTON_WHEEL_UP:
			$Camera2D.zoom *= 0.9

		if event.button_index == BUTTON_WHEEL_DOWN:
			$Camera2D.zoom /= 0.9

	if event is InputEventMouseMotion && _moveCamera:
		get_tree().set_input_as_handled();
		$Camera2D.position += (_previousPosition - event.position) * $Camera2D.zoom;
		_previousPosition = event.position;
