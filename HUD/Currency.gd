extends Control


onready var currency = $HBoxContainer/Current
onready var currency_change = $HBoxContainer/Expected


func _ready():
	pass

func updateUI():
	var current_currency = MapVariables.currency
	var current_currency_change = MapVariables.currency_change
	
	currency.text = "%05d" % current_currency
	currency_change.text = str(current_currency_change)
