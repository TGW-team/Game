extends Node

@onready var values_list     = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer

@onready var pop_number      = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer/PopulationNumber
@onready var literacy_number = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer/Literacy
@onready var industry        = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer/Industry
@onready var landscape       = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer/Landscape
@onready var ideology        = $VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer/Ideology


func show_region_settings(region):
	pass


func check_box_is_pressed(button_name):
	values_list.get_node(button_name)


func pop_number_is_changed():
	match get_selected_value(pop_number):
		"Very few":
			pass
		"Few":
			pass
		"Normal":
			pass
		"Many":
			pass


func literacy_is_changed():
	float(get_selected_value(literacy_number))


func industry_is_changed(industry_type: String):
	pass


func landscape_is_changed(landscape_type: String):
	pass


func rmc_is_changed(button_name: String):
	values_list.get_node(button_name)


func ideology_is_changed(ideology: String):
	pass


func get_selected_value(node: OptionButton):
	var id    = node.get_item_text(node.get_selected_id())
	var index = node.get_item_index(id)
	return node.get_item_text(index)
