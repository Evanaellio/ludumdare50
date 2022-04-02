extends Control

signal on_building_selected(building_id)

onready var build_button = $BuildButton
onready var build_panel = $BuildPanel

var building = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	build_button.connect("pressed", self, "_build_button_pressed")
	build_panel.visible = false

func _build_button_pressed():
	build_panel.visible = !build_panel.visible
	building = -1

func _on_ItemList_housing_item_selected(index):
	if index == 0:
		building = 2 # house

func _on_ItemList_water_item_selected(index):
	if index == 0:
		building = 3 # pump
	if index == 1:
		building = -1 # tank TODO
	if index == 2:
		building = -1 # evaporator TODO
	if index == 3:
		building = 4 # dam

func _on_ItemList_misc_item_selected(index):
	if index == 0:
		building = 0 # city hall

func _on_ItemList_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == false and building > -1:
			emit_signal("on_building_selected", building)
			build_panel.visible = false
