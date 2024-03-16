extends Panel

@onready var g_name = $VBoxContainer/Name
@onready var price  = $VBoxContainer/Price
@onready var output = $VBoxContainer/Output
@onready var demand = $VBoxContainer/Demand


@export var showing_good: Good


func show_good_info():
	var market: LocalMarket = SceneStorage.get_player_client().economy_manager.local_market
	
	g_name.text = "Name: "    + str(showing_good.good_name)
	price.text  = "Price: "   + str(market.goods_info[showing_good].price)
	output.text = "Output: " + str(market.goods_info[showing_good].supply)
	demand.text = "Demand: " + str(market.goods_info[showing_good].demand)
