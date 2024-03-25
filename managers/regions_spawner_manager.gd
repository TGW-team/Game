class_name RegionsSpawnerManager
extends RefCounted


func spawn_regions(map: Node2D):
	for map_node in map.get_children():
		var region = DbRegion.new()
		map_node.db_region_link = region


func give_region_to_polity():
	pass
