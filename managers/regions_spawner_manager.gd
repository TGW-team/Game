class_name RegionsSpawnerManager
extends RefCounted


var colors: Dictionary = {}


func spawn_regions(map: Node2D):
	for map_node in map.get_children():
		var region = DbRegion.new()
		map_node.db_region_link = region


func give_region_to_polity(region: Node2D):
	var country_path = colors[region.get_node("Sprite").modulate]


func set_color_dict():
	var dir = DirAccess.open("res://resources/countries/")
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var state_res  = load("res://resources/countries/" + file_name)
		colors[state_res.color] = "res://resources/countries/" + file_name
