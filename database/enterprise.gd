class_name DbEnterprise
extends Resource

const CLERKS_LABOUR_PRODUCTIVITY:    float = 2 #* PopulationWorldManager.POP_COEF
const CRAFTSMEN_LABOUR_PRODUCTIVITY: float = 0.01 #* PopulationWorldManager.POP_COEF
const LABOURERS_LABOUR_PRODUCTIVITY: float = 0.1 #* 0.1 * PopulationWorldManager.POP_COEF

var storage: Array[StorageGood]

var money:           float = 0.0
var size:              int = 1000 #Вместимость
var closed:           bool = false
var ready_to_produce: bool = true
var produced_good:    Good

# ACCOUNTING
var produced_good_number: float = 0.0
var profit:               float = 0.0
var income:               float = 0.0

var wage_expenses:        float = 0.0
# ACCOUNTING

class StorageGood:
	var good_res: Good
	var current_number:    float = 0.0
	var required_number:   float = 0.0
	var resource_per_good: float = 0.0
	
	func _init(storage_good_res: StorageGoodRes):
		good_res          = storage_good_res.good_res
		resource_per_good = storage_good_res.required_number
	
	func set_required_number(total_number_workers: int):
		required_number = resource_per_good * total_number_workers


func set_storage(raw_materials_list):
	for res in raw_materials_list:
		var storage_good = StorageGood.new(res)
		storage.append(storage_good)


func reduce_money(number: int, expenses_var: String):
	money -= number
	set(expenses_var, number)


func hire_workers(pop_unit: PopUnit, number: int):
	var worker_var = "employed_" + pop_unit.pop_type.pop_type_name
	
	pop_unit.unemployed_quantity -= number
	set(worker_var, get(worker_var) + number)


func fire_workers(pop_unit: PopUnit, number: int):
	var worker_var = "employed_" + pop_unit.pop_type.pop_type_name
	
	pop_unit.unemployed_quantity += number
	set(worker_var, get(worker_var) - number)


func get_profit():
	return income - wage_expenses
