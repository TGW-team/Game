class_name Client
extends Node


var state_name: String = ""
var state_res: State

# MANAGERS
var accounting_manager = AccountingManager.new()
var diplomacy_manager  = DiplomacyManager.new()
var economy_manager    = EconomyManager.new()
var politics_manager   = PoliticsManager.new()
var population_manager = PopulationManager.new()
# MANAGERS


func _init(_state_res: State):
	state_res = _state_res
	state_name = state_res.state_name
	politics_manager.set_parties(self)
	politics_manager.set_government(state_res.starting_government)


func add_money_to_budget(money: float, accounting_pos: String):
	economy_manager.state_budget += money
	accounting_manager.add_value(accounting_pos, money)
