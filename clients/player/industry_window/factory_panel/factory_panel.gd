extends Panel

@onready var produced_good      = $VBoxContainer/HBoxContainer/Button
@onready var raw_materials_list = $VBoxContainer/HBoxContainer3
@onready var progress_bar       = $VBoxContainer/VBoxContainer/ProgressBar
@onready var workers_number     = $VBoxContainer/VBoxContainer/Label
@onready var profit             = $VBoxContainer/HBoxContainer4/Profit
@onready var good_number        = $VBoxContainer/HBoxContainer4/GoodNumber

var factory: Factory


func start(focused_factory: Factory):
	factory = focused_factory
	visible = true
	update_info()


func update_info():
	set_raw_materials_list()
	set_profit_button()
	produced_good.icon     = factory.produced_good.icon
	progress_bar.max_value = factory.size
	progress_bar.value     = factory.employed_craftsmen + factory.employed_clerks
	workers_number.text    = "Craftsmen: " + str(factory.employed_craftsmen) + "\n"
	workers_number.text   += "Clerks: "    + str(factory.employed_clerks)
	good_number.text       = str(factory.produced_good_number) + " Q"


func set_profit_button():
	var factory_profit = factory.get_profit()
	
	if factory_profit > 0:
		profit.text = "+" + str(factory_profit)
	elif factory_profit < 0:
		profit.text = str(factory_profit)
	profit.text += "$"


func set_raw_materials_list():
	var counter  = 0
	var children = raw_materials_list.get_children()
	
	for i in factory.storage:
		children[counter].texture = i.good_res.icon
		children[counter].visible = true
		counter += 1
