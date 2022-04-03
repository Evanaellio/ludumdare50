extends Control


var selected_sim_speed = SpeedSettings.Speed.Speed1

signal on_sim_speed_changed(speed)

func _ready():
	pass # Replace with function body.


func _on_SpeedList_item_selected(index):
	match index:
		0:
			selected_sim_speed = SpeedSettings.Speed.Speed0
		1:
			selected_sim_speed = SpeedSettings.Speed.Speed1
		2:
			selected_sim_speed = SpeedSettings.Speed.Speed2
	
	emit_signal("on_sim_speed_changed", selected_sim_speed)
