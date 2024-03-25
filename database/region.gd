class_name DbRegion
extends Resource

var core_countries:           Array[Country]

var projects_list:              Array = []
var factories_list:             Array = []
var rmc_list:                   Array = []

var produced_goods:             Array = []

var region_name:    String         = "0001"
var pop_units_list: Array[PopUnit] = [PopUnit.new("labourers"), PopUnit.new("craftsmen"), PopUnit.new("clerks"), PopUnit.new("bureaucrats")]



#func set_region_owner(new_owner: DbPolity):
	#var old_owner = get_parent()
	#
	#get_parent().remove_child(self)
	#new_owner.add_child(self)
	#
	#for i in factories_list + rmc_list:
		#i.economy_manager_link = new_owner.economy_manager
	#
	#for i in pop_units_list:
		#i.pay_tax_func = new_owner.add_money_to_budget
		#i.get_tax_func = new_owner.economy_manager.get_tax
	#
	#if old_owner is DbPolity:
		#old_owner.population_manager.erase_pop_units(pop_units_list)
	#new_owner.population_manager.register_pop_units(pop_units_list)
	

func distribute_workforce():
	pop_units_list[0].distribute_unemployed(rmc_list)
	pop_units_list[1].distribute_unemployed(factories_list)


func get_population_unit(soc_class: String):
	match soc_class:
		"labourers":
			return pop_units_list[0]
		"craftsmen":
			return pop_units_list[1]
		"clerks":
			return pop_units_list[2]
		"bureaucrats":
			return pop_units_list[3]


func get_population_number():
	var number = 0
	
	for i in pop_units_list:
		number += i.total_quantity
	
	return number
