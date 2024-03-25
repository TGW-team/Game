@tool
extends Node

@onready var map            = preload("res://addons/tgwassethelper/scenes/map.tscn")
@onready var sprite_factory = preload("res://addons/tgwassethelper/scenes/sprite_factory_form.tscn")

@onready var values_list     = $MapEditor/Sidebar/VBoxContainer
@onready var hud_container   = $MapEditor/VBoxContainer

@onready var pop_number      = $MapEditor/Sidebar/VBoxContainer/PopulationNumber
@onready var literacy_number = $MapEditor/Sidebar/VBoxContainer/Literacy
@onready var industry        = $MapEditor/Sidebar/VBoxContainer/Industry
@onready var landscape       = $MapEditor/Sidebar/VBoxContainer/Landscape
@onready var ideology        = $MapEditor/Sidebar/VBoxContainer/Ideology


var showed_element


func show_region_settings(region):
	remove_showed_element()
	hud_container.add_child(map.instantiate())


func show_map():
	set_showed_element(map)


func show_sprite_factory():
	set_showed_element(sprite_factory)


func set_showed_element(el):
	remove_showed_element()
	var node = el.instantiate()
	hud_container.add_child(node)
	showed_element = node


func remove_showed_element():
	if showed_element != null:
		hud_container.remove_child(showed_element)


func check_box_is_pressed(button_name):
	values_list.get_node(button_name)


func rmc_is_changed(button_name: String):
	values_list.get_node(button_name)


func get_selected_value(node: OptionButton):
	var id    = node.get_item_text(node.get_selected_id())
	var index = node.get_item_index(id)
	return node.get_item_text(index)
