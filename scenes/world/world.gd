extends Node2D


@onready var map    = $Map
@onready var player = $Player
@onready var timer  = $DateManager


func _ready():
	set_clients()
	player.find_client()
	
	set_demo_region()


func set_demo_region():
	var node   = get_node("Region")
	var client = get_node("Map").get_children()[0]
	node.set_region_owner(client)
	

func set_clients():
	var path = "res://resources/states/"
	var dir  = DirAccess.open(path)
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var state_res = load(path + file_name)
		
		spawn_client(state_res)


func spawn_client(state_res):
	var client = Client.new(state_res)
	map.add_child(client)
