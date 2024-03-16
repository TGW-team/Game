@tool
extends Button


@export var good: Good

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = good.icon
	GlobalMainLoop.connect("new_day", update_text)
	

func update_text():
	var market = SceneStorage.get_player_client().economy_manager.local_market
	text = str(market.get_good_value(good, "price")) + "$" + "\n"
	text += str(market.get_good_value(good, "quantity")) + "Q"


func _pressed():
	get_parent().get_parent().get_parent().showing_good = good
	get_parent().get_parent().get_parent().show_good_info()
