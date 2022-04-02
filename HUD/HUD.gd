extends Control


onready var build_button = $BuildButton
onready var build_panel = $BuildPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	build_button.connect("pressed", self, "_build_button_pressed")

func _build_button_pressed():
	build_panel.popup()
