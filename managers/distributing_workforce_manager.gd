class_name DistributingWorkforceManager
extends RefCounted

const DISTRIBUTING_WORKERS_LOOP_1: Array[float] = [0.5, 0.25, 0.12, 0.06, 0.04, 0.03]
const DISTRIBUTING_WORKERS_LOOP_2: Array[float] = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5,]
const DISTRIBUTING_WORKERS_LOOP_3: Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,]


func distribute_unemployed_in_world():
	pass


func distribute_unemployed(pop_unit: PopUnit, enterprises_list: Array):
	var loop_list = DISTRIBUTING_WORKERS_LOOP_1
	var unemployed_quantity = pop_unit.unemployed_quantity
	
	if unemployed_quantity < 100:
		loop_list = DISTRIBUTING_WORKERS_LOOP_2
	if unemployed_quantity < 10:
		loop_list = DISTRIBUTING_WORKERS_LOOP_3
	
	var worker_var                  = "employed_" + pop_unit.pop_type.pop_type_name
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
