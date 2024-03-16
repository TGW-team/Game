class_name  Party
extends RefCounted


var party_name: String = "PARTY_NAME"
var ideology: Resource

var economic_policy: EconomicPolicy
var trade_policy:    TradePolicy
var military_policy: MilitaryPolicy


func _init(_ideology):
	ideology = _ideology
	
	economic_policy = ideology.economic_policy
	trade_policy    = ideology.trade_policy
	military_policy = ideology.military_policy
