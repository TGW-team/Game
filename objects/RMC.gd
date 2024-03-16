class_name RMC
extends Enterprise


var employed_labourers: int = 0


func get_free_space():
	return size - employed_labourers


func _init(res: EnterpriseType, get_pop_func: Callable):
	enterprise_res = res
	produced_good  = enterprise_res.produced_good
	get_pop_unit   = get_pop_func
	set_storage(enterprise_res.raw_materials_list)
	GlobalMainLoop.connect("produce_goods", produce_goods)
	GlobalMainLoop.connect("pay_wages", pay_wages)


func produce_goods():
	income               = 0.0
	produced_good_number = 0.0
	if ready_to_produce and employed_labourers > 0:
		var production_eff_manager = economy_manager_link.production_eff_manager
		var rmc_efficiency         = production_eff_manager.rmc_efficiency
		var prod_eff_branch        = production_eff_manager.production_efficiency[enterprise_res.production_type]
		
		var efficiency           = enterprise_res.basic_production_eff + rmc_efficiency + prod_eff_branch
		var workers_productivity = employed_labourers * LABOURERS_LABOUR_PRODUCTIVITY
		var goods_number         = (efficiency * workers_productivity) * enterprise_res.basic_production_eff
		
		for good in enterprise_res.further_produced_goods + [produced_good]:
			income               += economy_manager_link.local_market.sell_goods(good, goods_number)
			produced_good_number += goods_number
		
		money += income


func pay_wages():
	var min_wage  = economy_manager_link.MIN_WAGE
	var labourers = get_pop_unit.call("labourers")
	var wage      = min_wage * employed_labourers
	
	labourers.add_money(wage)
	reduce_money(wage, "wage_expenses")
