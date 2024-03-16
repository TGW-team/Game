class_name Region
extends TextureButton

@export var core_state:           State

var projects_list:              Array = []
var factories_list:             Array = [
		Factory.new(load("res://resources/factories/distillery.tres"),    get_population_unit),
		Factory.new(load("res://resources/factories/glass_factory.tres"), get_population_unit),
		Factory.new(load("res://resources/factories/oil_plant.tres"),     get_population_unit),
		Factory.new(load("res://resources/factories/steel_plant.tres"),   get_population_unit),]
var rmc_list:                   Array = [
		RMC.new(load("res://resources/rmc/coal_mine.tres"),       get_population_unit),
		RMC.new(load("res://resources/rmc/grain_farm.tres"),      get_population_unit),
		RMC.new(load("res://resources/rmc/iron_mine.tres"),       get_population_unit),
		RMC.new(load("res://resources/rmc/livestock_farms.tres"), get_population_unit),]

var produced_goods:             Array = []

var region_name:    String         = "0001"
var pop_units_list: Array[PopUnit] = [PopUnit.new("labourers"), PopUnit.new("craftsmen"), PopUnit.new("clerks"), PopUnit.new("bureaucrats")]

# DEBUG 

# DEBUG 

func _init():
	GlobalMainLoop.connect("distribute_workforce", distribute_workforce)


func _pressed():
	SceneStorage.player.region_window.region_is_pressed(self)


func set_region_owner(new_owner: Client):
	var old_owner = get_parent()
	
	get_parent().remove_child(self)
	new_owner.add_child(self)
	
	for i in factories_list + rmc_list:
		i.economy_manager_link = new_owner.economy_manager
	
	for i in pop_units_list:
		i.pay_tax_func = new_owner.add_money_to_budget
		i.get_tax_func = new_owner.economy_manager.get_tax
	
	if old_owner is Client:
		old_owner.population_manager.erase_pop_units(pop_units_list)
	new_owner.population_manager.register_pop_units(pop_units_list)
	

func distribute_workforce():
	pop_units_list[0].distribute_unemployed(rmc_list)
	pop_units_list[1].distribute_unemployed(factories_list)
	#print()


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


func get_region_owner():
	return get_parent()


func get_population_number():
	var number = 0
	
	for i in pop_units_list:
		number += i.total_quantity
	
	return number
