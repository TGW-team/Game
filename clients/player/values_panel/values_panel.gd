extends Panel


@onready var aggressiveness    = $HBoxContainer/Value
@onready var literacy          = $HBoxContainer/Value2
@onready var population_growth = $HBoxContainer/Value3
@onready var unemployment      = $HBoxContainer/Value4
@onready var welfare           = $HBoxContainer/Value5
@onready var pop_number        = $HBoxContainer/Value6
@onready var money             = $HBoxContainer/Value7


func update_info():
	var accounting_manager = SceneStorage.get_player_client().accounting_manager
	var ec_manager         = SceneStorage.get_player_client().economy_manager
	
	aggressiveness.set_text(accounting_manager.average_aggressiveness)
	literacy.set_text(accounting_manager.average_literacy)
	welfare.set_text(accounting_manager.poor_average_welfare)
	
	population_growth.set_text(accounting_manager.pop_growth)
	unemployment.set_text(accounting_manager.total_unemployment)
	
	pop_number.set_text(accounting_manager.total_population)
	
	money.set_text(ec_manager.state_budget)
