extends Node


var state_list: Array[DbPolity] = []


func _ready():
	set_polities()


func set_polities():
	var path = "res://resources/countries/"
	var dir  = DirAccess.open(path)
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var country_res = load(path + file_name)
		
		state_list.append(SceneStorage.polities_spawner_manager.create_polity(country_res))
