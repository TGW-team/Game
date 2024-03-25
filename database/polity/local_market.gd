class_name DbLocalMarket
extends Resource


var goods_info: Dictionary = {}


func _init():
	set_market()


func set_market():
	var dir = DirAccess.open("res://resources/goods/")
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var good_res: Good = load("res://resources/goods/" + file_name)
		goods_info[good_res] = {
			"quantity": 0.0,
			"price":    good_res.basic_price,
			"demand":   0.0,
			"supply":   0.0,
			"import":   0.0,
			"export":   0.0,
		}


func clear_market():
	for good_res in goods_info:
		var dict = goods_info[good_res]
		
		dict.quantity = 0.0
		dict.demand   = 0.0
		dict.supply   = 0.0
		dict.import   = 0.0
		dict.export   = 0.0


func get_good_value(good: Good, value: String):
	return goods_info[good].get(value)


func add_good_value(good: Good, value: String, number: float):
	goods_info[good][value] += number


func sell_goods(good: Good, number: float):
	var income = get_good_value(good, "quantity") * number
	add_good_value(good, "quantity", number)
	add_good_value(good, "supply", number)
	return income


func buy_goods(good: Good, number: float):
	var expense = get_good_value(good, "price") * number
	add_good_value(good, "quantity", -number)
	add_good_value(good, "demand", number)
	return expense


func buy_import_goods(good: Good, number: float):
	var expense = (get_good_value(good, "price") * number)
	add_good_value(good, "demand", number)
	return expense


func goods_on_market_enough(good: Good, number: float):
	if number >= get_good_value(good, "quantity"):
		return true
	else:
		return false


func get_import_goods_number(good: Good, number: float):
	var good_q = get_good_value(good, "quantity")
	if good_q < number:
		return number - good_q
	return 0.0
