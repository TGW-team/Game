extends Button

var state_res: Resource


func start(state_res_):
	state_res = state_res_
	text = state_res.state_name


func _pressed():
	SceneStorage.starting_state = state_res
	var _err = get_tree().change_scene_to_file("res://scenes/world/world.tscn")
