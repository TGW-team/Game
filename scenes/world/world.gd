extends Node2D


@onready var map    = $Map
@onready var player = $Client
@onready var timer  = $DateManager


func _ready():
	set_clients()
	

func set_clients():
	var path = "res://resources/states/"
	var dir  = DirAccess.open(path)
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var state_res = load(path + file_name)
		
