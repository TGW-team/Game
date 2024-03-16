class_name PopulationManager
extends RefCounted


var pop_units_list: Array[PopUnit] = []


func register_pop_units(pop_units: Array):
	pop_units_list.append_array(pop_units)


func erase_pop_units(pop_units: Array):
	for i in pop_units:
		pop_units_list.erase(pop_units)
