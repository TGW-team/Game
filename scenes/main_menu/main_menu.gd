extends Node2D


@onready var main_buttons_container: VBoxContainer = $MainButtons
@onready var choose_state_container: VBoxContainer = $ChooseState
@onready var example_button:         Button        = $ExampleButton



func _ready():
	set_state_buttons()


func singleplayer_button_pressed():
	main_buttons_container.visible = false
	choose_state_container.visible = true


func set_state_buttons():
	var dir = DirAccess.open("res://resources/countries/")
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var new_button = example_button.duplicate()
		var state_res  = load("res://resources/countries/" + file_name)
		
		new_button.set_script(load("res://scenes/main_menu/state_button.gd"))
		new_button.start(state_res)
		
		choose_state_container.add_child(new_button)
		
