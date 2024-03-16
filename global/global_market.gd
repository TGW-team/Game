extends Node


var goods_quantity: Dictionary = {}


func set_goods_quantity():
	var dir = DirAccess.open("res://resources/goods/")
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var good_res = load("res://resources/states/" + file_name)
		goods_quantity[good_res] = 0.0
