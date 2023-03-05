extends Node2D


func _ready():
	TranslationServer.set_locale("en")


func ChangeScene(name_of_country):
	Players.country_to_start = name_of_country
	var _err = get_tree().change_scene("res://Scenes/Game/Game.tscn")


func one_player():
	hide()
	$ScrollContainer.visible = true
	$VBoxContainer2.visible = true

func multiplayer_():
	hide()
	

func developer_guide():
	var _err = get_tree().change_scene("res://Scenes/DeveloperGuide/DeveloperGuide.tscn")
	
	
func hide():
	$VBoxContainer.visible = false
	$Label2.visible        = false


func path_editor():
	var _err = get_tree().change_scene("res://Scenes/MapEditor/MapEditor.tscn")
