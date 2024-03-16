extends Panel


@onready var state_name = $VBoxContainer/StateName
@onready var date_label = $VBoxContainer/Date


func _ready():
	GlobalMainLoop.connect("new_day", update_info)


func update_info():
	var date_manager = SceneStorage.date_manager
	var client       = SceneStorage.get_player_client()
	date_label.text  = str(date_manager.day) + "." + str(date_manager.month) + "." + str(date_manager.year)
	state_name.text  = client.state_name
