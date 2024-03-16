extends Button


@export var node_name: String = ""


func _pressed():
	get_parent().get_parent().get_parent().open_window(node_name)
	pass
