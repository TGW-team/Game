class_name EconomyManager
extends RefCounted

const MIN_TAXES:           float = 0.0
const MAX_TAXES:           float = 0.3
const MIN_TARIFFS:         float = -0.1
const MAX_TARIFFS:         float = 0.5
const MIN_WAGE:            float = 0.5 # Min wage of Craftsmen and Clerks

var factories_list: Array[Factory] = []
var rmc_list:       Array[RMC]     = []

var state_budget: float = 0.0

var local_market:          LocalMarket   = LocalMarket.new()

var costs_education:   float = 0.0 # from 0 to 1
var costs_pensions:    float = 0.0 # from 0 to 1
var costs_army_supply: float = 0.0 # from 0 to 1
var costs_bureaucrats: float = 0.0 # from 0 to 1

var tariffs:              Tax = Tax.new()
var poor_classes_taxes:   Tax = Tax.new()
var middle_classes_taxes: Tax = Tax.new()
var rich_classes_taxes:   Tax = Tax.new()

var production_eff_manager: ProductionEffManager = ProductionEffManager.new()


func _init():
	GlobalMainLoop.connect("clear_markets", local_market.clear_market)


func get_tax(pop_type: PopType):
	return get(pop_type.tax_kind).tax_value
