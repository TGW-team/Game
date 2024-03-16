extends Node2D

signal region_pressed

@export var region_id: String

@onready var region_button: TextureButton = get_node('Button')
@onready var hover_effect: Sprite2D = get_node("HoverEffect")


func _ready():
	region_button.mouse_entered.connect(_on_region_button_mouse_entered)
	region_button.mouse_exited.connect(_on_region_button_mouse_exited)
	region_button.pressed.connect(_on_region_button_pressed)


func _on_region_button_pressed():
	print(str("pressed ", region_id))
	emit_signal("region_pressed")


func _on_region_button_mouse_entered():
	hover_effect.show()


func _on_region_button_mouse_exited():
	hover_effect.hide()
