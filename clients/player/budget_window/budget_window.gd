extends Panel


@onready var container = $VBoxContainer


func update_info():
	for i in container.get_children():
		i.update_info()
	pass
