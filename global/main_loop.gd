extends Node

signal produce_goods
signal buy_factory_equipment
signal buy_raw_materials
signal pay_wages
signal buy_consumer_goods

signal clear_accounted_values
signal clear_markets
signal distribute_workforce

signal set_accounted_values

signal new_day


func new_day_loop():
	emit_signal("new_day")
	clear_data()
	
	economy_loop()
	emit_signal("set_accounted_values")
	update_gui()
	

func update_gui():
	var player = SceneStorage.player
	
	player.budget_window.update_info()
	player.politics_window.update_info()
	player.values_panel.update_info()
	player.region_window.update_info()
	player.industry_window.update_info()
	player.production_window.show_good_info()
	#player.production_window.update_info()


func economy_loop():
	emit_signal("distribute_workforce")
	emit_signal("produce_goods")
	emit_signal("pay_wages")
	

func clear_data():
	emit_signal("clear_markets")
	emit_signal("clear_accounted_values")
