extends HBoxContainer

@export var pop_unit_index: int = 0

@onready var pop_type_icon = $TextureRect
@onready var pop_type      = $Label
@onready var pop_number    = $Label2
@onready var income        = $Label3

var pop_unit: PopUnit


func set_info(pop_units_list: Array):
	pop_unit = pop_units_list[pop_unit_index]
	pop_type_icon.texture = pop_unit.pop_type.pop_type_icon


func update_info():
	pop_type.text   = pop_unit.pop_type.pop_type_name
	pop_number.text = str(pop_unit.total_quantity)
	income.text     = str(pop_unit.income)
