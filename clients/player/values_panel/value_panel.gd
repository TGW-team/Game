@tool
extends HBoxContainer

@onready var icon_node  = $Icon
@onready var value_text = $Value

@export var icon: Texture2D


func _ready():
	icon_node.texture = icon


func set_text(number):
	if number >= 1000:
		number = float(number) / 1000
		number = str(number) + "k"
	elif number >= 1000000:
		number = float(number) / 1000000
		number = str(number) + "M"
	
	value_text.text = str(number)
