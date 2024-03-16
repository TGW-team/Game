class_name Factory
extends Enterprise

var employed_craftsmen: int = 0
var employed_clerks:    int = 0


func _init(res: EnterpriseType, get_pop_func: Callable):
	enterprise_res = res
	produced_good  = enterprise_res.produced_good
	get_pop_unit   = get_pop_func
	set_storage(enterprise_res.raw_materials_list)
	GlobalMainLoop.connect("produce_goods", produce_goods)
	GlobalMainLoop.connect("pay_wages", pay_wages)


func get_free_space():
	return size - (employed_clerks + employed_craftsmen)
	

func produce_goods():
	if ready_to_produce and employed_craftsmen > 0:
		var production_eff_manager = economy_manager_link.production_eff_manager
		var factories_efficiency   = production_eff_manager.factories_efficiency
		var prod_eff_branch        = production_eff_manager.production_efficiency[enterprise_res.production_type]
		
		var efficiency           = enterprise_res.basic_production_eff + factories_efficiency + prod_eff_branch
		var workers_productivity = employed_craftsmen * CRAFTSMEN_LABOUR_PRODUCTIVITY
		var goods_number         = efficiency * workers_productivity
		
		income               = economy_manager_link.local_market.sell_goods(produced_good, goods_number)
		produced_good_number = goods_number
		
		money += income


func pay_wages():
	var min_wage  = economy_manager_link.MIN_WAGE
	var craftsmen = get_pop_unit.call("craftsmen")
	var craftsmen_wage = min_wage * employed_craftsmen
	var clerks_wage    = 0.0
	
	craftsmen.add_money(craftsmen_wage)
	reduce_money(craftsmen_wage + clerks_wage, "wage_expenses")


func buy_raw_materials():
	pass
