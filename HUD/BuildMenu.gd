extends Control

signal on_building_selected(building_id)

onready var build_button = $BuildButton
onready var build_panel = $BuildPanel
onready var cost_tracker = $BuildPanel/Misc/HBoxContainer/CostTracker/Cost

var building = BuildingSettings.BuildingID.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	build_button.connect("pressed", self, "_build_button_pressed")
	build_panel.visible = false

func _build_button_pressed():
	build_panel.visible = not build_panel.visible
	building = BuildingSettings.BuildingID.NONE

#func _on_ItemList_housing_item_selected(index):
#	if index == 0:
#		building = BuildingSettings.BuildingID.House
#
#func _on_ItemList_water_item_selected(index):
#	if index == 0:
#		building = BuildingSettings.BuildingID.Pump
#	if index == 1:
#		building = BuildingSettings.BuildingID.NONE # tank TODO
#	if index == 2:
#		building = BuildingSettings.BuildingID.NONE # evaporator TODO
#	if index == 3:
#		building = BuildingSettings.BuildingID.Dam

func _on_ItemList_misc_item_selected(index):
	match index:
		0:
			building = BuildingSettings.BuildingID.Dam
		1:
			building = BuildingSettings.BuildingID.House
		2:
			building = BuildingSettings.BuildingID.Bridge
	
	cost_tracker.text = "%d€" % BuildingSettings.buildings_cost[building]

func _on_ItemList_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == false and building > -1:
			emit_signal("on_building_selected", building)
			build_panel.visible = false
