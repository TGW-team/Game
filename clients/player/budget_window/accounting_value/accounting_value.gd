@tool
extends VBoxContainer


@onready var value_label = $Value
@onready var value_name  = $HBoxContainer/ExpenseName
@onready var percent     = $HBoxContainer/Percent

@export var expense_variable:    String = ""
@export var accounting_variable: String = ""
@export var expense_gui_name:    String = ""

@export var step: float = 0.01


func _ready():
	value_name.text = expense_gui_name


func update_info():
	var economy_manager    = SceneStorage.get_player_client().economy_manager
	var accounting_manager = SceneStorage.get_player_client().accounting_manager
	
	percent.text = "(" + str(int(economy_manager.get(expense_variable).tax_value * 100)) + "%)"
	value_label.text = str(accounting_manager.get(accounting_variable)) + "$"


func reduce_value():
	SceneStorage.get_player_client().economy_manager.get(expense_variable).reduce_tax(-step)
	update_info()


func increase_value():
	SceneStorage.get_player_client().economy_manager.get(expense_variable).increase_tax(step)
	update_info()
