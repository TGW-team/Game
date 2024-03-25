class_name ConsumptionManager
extends Node



func update_buying_resources(client: DbPolity):
	pass


func update_consumption(client: DbPolity):
	for i in client.population_manager.pop_units_list:
		buy_consumer_goods(i, client.economy_manager.local_market)


func buy_consumer_goods(pop_unit: DbPopUnit, market: DbLocalMarket):
	for good_need in pop_unit.pop_type.needs_list:
		var good          = good_need.good
		var good_quantity = good_need.quantity * pop_unit.total_quantity
		var expense       = 0.0
		
		if market.goods_on_market_enough(good, good_quantity):
			if (good_quantity * market.get_good_value(good, "price")) < pop_unit.money:
				expense = market.buy_goods(good, good_quantity)
		
		#else:
			#var im_goods_q = market.get_import_goods_number(good, good_quantity)
			#good_quantity  = good_quantity - im_goods_q
			#
			#expense = market.buy_import_goods(good, im_goods_q) + market.buy_goods(good, good_quantity)


func buy_good():
	pass
