class_name DbPolity
extends Resource


var polity_name: String = ""
var country:     Country

var regions_list:      Array[DbRegion]      = []
var parties_list:      Array[DbParty]       = []
var taxes_list:        Array[DbTax]         = [DbTax.new(), DbTax.new(), DbTax.new(), DbTax.new()]
var institutions_list: Array[DbInstitution] = []

var local_market: DbLocalMarket
var government:   GovernmentForm


## MANAGERS
#var accounting_manager = AccountingManager.new()
#var diplomacy_manager  = DiplomacyManager.new()
#var economy_manager    = EconomyManager.new()
#var politics_manager   = PoliticsManager.new()
#var population_manager = PopulationManager.new()
## MANAGERS
#
#
	#politics_manager.set_parties(self)
	#politics_manager.set_government(state_res.starting_government)
#
#
#func add_money_to_budget(money: float, accounting_pos: String):
	#economy_manager.state_budget += money
	#accounting_manager.add_value(accounting_pos, money)
