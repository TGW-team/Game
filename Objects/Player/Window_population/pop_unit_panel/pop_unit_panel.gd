extends HBoxContainer


@onready var pop_type_label:          Label = $pop_type
@onready var region_label:            Label = $region
@onready var quantity_label:          Label = $quantity
@onready var pop_growth_label:        Label = $pop_growth
@onready var welfare_label:           Label = $welfare
@onready var money_label:             Label = $money
@onready var aggressiveness_label:    Label = $aggressiveness
@onready var pol_reform_label:        Label = $pol_reform_desire
@onready var soc_reform_label:        Label = $soc_reform_desire


var pop_unit: PopulationUnit


func update(population_units_list):
	if pop_unit.quantity == 0:
		visible = false
	else:
		visible = true
	
	if not population_units_list.has(pop_unit):
		get_parent().get_parent().accounted_pop_units_list.erase(self)
		queue_free()
	
	else:
		pop_type_label.text   = str(pop_unit.population_type.display_name)
		region_label.text     = str(pop_unit.region.name_of_tile)
		quantity_label.text   = str(pop_unit.quantity)
		pop_growth_label.text = str(pop_unit.population_growth)
		welfare_label.text    = str(pop_unit.welfare)
		money_label.text      = str(snapped(pop_unit.money, 0.1))
		aggressiveness_label.text      = str(snapped(pop_unit.aggressiveness, 0.1))
		pol_reform_label.text = str(pop_unit.pol_reform_desire)
		soc_reform_label.text = str(pop_unit.soc_reform_desire)