extends Panel

@onready var party_name      = $VBoxContainer/PartyName
@onready var trade_policy    = $VBoxContainer/Trade
@onready var economic_policy = $VBoxContainer/Economy
@onready var military_policy = $VBoxContainer/Army

var party: Party


#get_node("VBoxContainer/Trade").text   = "Trade policy: "    + party.trade_policy.policy_name
#get_node("VBoxContainer/Economy").text = "Economic policy: " + party.economic_policy.policy_name
#get_node("VBoxContainer/Army").text    = "Military policy: " + party.military_policy.policy_name


func set_info(_party: Party):
	party = _party
	visible = true
	
	get_node("VBoxContainer/PartyName").text = party.party_name
	get_node("VBoxContainer/Trade").text     = "Trade policy: "    + party.trade_policy.policy_name
	get_node("VBoxContainer/Economy").text   = "Economic policy: " + party.economic_policy.policy_name
	get_node("VBoxContainer/Army").text      = "Military policy: " + party.military_policy.policy_name
	
	get_node("VBoxContainer/PartyName").icon = party.ideology.icon
	
