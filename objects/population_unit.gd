class_name PopUnit
extends RefCounted

const DISTRIBUTING_WORKERS_LOOP_1:   Array[float] = [0.5, 0.25, 0.12, 0.06, 0.04, 0.03]
const DISTRIBUTING_WORKERS_LOOP_2: Array[float] = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5,]
const DISTRIBUTING_WORKERS_LOOP_3: Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,]

var money:          float = 0.0
var welfare:          int = 0
var literacy:       float = 0.0
var aggressiveness: float = 0.0
var migration_attractiveness: int = 0
var pop_type: PopType

#var employed_quantity:   int = 0
var unemployed_quantity: int = 1000
var migrants_quantity:   int = 0
var total_quantity:      int = 1000

var income: float = 0.0

var get_tax_func: Callable
var pay_tax_func: Callable

func _init(res_path: String):
	pop_type = load("res://resources/population_types/" + res_path + ".tres")
	

func add_unemployed(number: int):
	unemployed_quantity += number
	total_quantity      += number


func distribute_unemployed(enterprises_list: Array):
	var loop_list = DISTRIBUTING_WORKERS_LOOP_1
	
	if unemployed_quantity < 100:
		loop_list = DISTRIBUTING_WORKERS_LOOP_2
	if unemployed_quantity < 10:
		loop_list = DISTRIBUTING_WORKERS_LOOP_3
	
	var worker_var                  = "employed_" + pop_type.pop_type_name
	var current_unemployed_quantity = unemployed_quantity
	
	for i in enterprises_list:
		var free_jobs = i.get_free_space()
		var ready_workers_number = int(loop_list[enterprises_list.find(i)] * current_unemployed_quantity)
		
		if free_jobs >= ready_workers_number:
			i.hire_workers(self, ready_workers_number)
			current_unemployed_quantity -= ready_workers_number
		
		elif free_jobs <= ready_workers_number:
			i.hire_workers(self, free_jobs)
			current_unemployed_quantity -= free_jobs
			
		if current_unemployed_quantity == 0:
			break
	

func add_money(number: float):
	var tax              = get_tax_func.call(pop_type) * number
	var income_after_tax = number - tax
	pay_tax_func.call(tax, pop_type.accounting_tax_kind)
	
	money  = income_after_tax
	income = income_after_tax
	
