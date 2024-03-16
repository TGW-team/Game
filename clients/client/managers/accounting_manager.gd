class_name AccountingManager
extends RefCounted

const ACCOUNTED_VALUES: Dictionary = {
	
	"average_aggressiveness": "aggressiveness",
	"average_literacy":       "literacy",
	"total_unemployment":     "unemployed_quantity",
	"total_population":       "total_quantity",
}

const AVERAGE_VALUES: Array = [
	"average_aggressiveness",
	"average_literacy",
]


var subsidies_expense:            float = 0.0 # Money
var army_supply_expense:          float = 0.0 # Money
var bureaucrats_expense:          float = 0.0 # Money

var education_expense:            float = 0.0 # Money
var pensions_expense:             float = 0.0 # Money
var unemployment_benefit_expense: float = 0.0 # Money

var tariffs_income:      float = 0.0 # Money
var poor_taxes_income:   float = 0.0 # Money
var middle_taxes_income: float = 0.0 # Money
var rich_taxes_income:   float = 0.0 # Money

var average_aggressiveness: float = 0.0
var average_literacy:       float = 0.0
var poor_average_welfare:   float = 0.0
var middle_average_welfare: float = 0.0
var rich_average_welfare:   float = 0.0

var pop_growth:             int = 0
var total_unemployment:     int = 0
var total_population:       int = 0

var craftsmen_unemployment: int = 0
var clerks_unemployment:    int = 0
var labourers_unemployment: int = 0


func _init():
	GlobalMainLoop.connect("set_accounted_values", check_values)
	GlobalMainLoop.connect("clear_accounted_values", clear_variables)


func clear_variables():
	var list: Array = get_script().get_script_property_list()
	list.erase(list[0])
	
	for i in list:
		set(i.name, 0.0)


func check_values():
	#for i in ACCOUNTED_VALUES:
		#set(i, 0.0)
	
	for region in SceneStorage.get_player_client().get_children():
		for pop_unit in region.pop_units_list:
			for variable in ACCOUNTED_VALUES:
				add_value(variable, pop_unit.get(ACCOUNTED_VALUES[variable]))
				
	set_values()


func set_values():
	for i in AVERAGE_VALUES:
		set(i, get(i) / float(total_population))


func add_value(variable_name: String, number: float):
	set(variable_name, get(variable_name) + number)
