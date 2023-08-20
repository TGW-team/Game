extends Panel

@onready var form_of_goverment_label      = $CharsOfCountry/FormOfGovernment
@onready var status_policy_label          = $CharsOfCountry/StatusPolicy
@onready var ruling_party_label           = $CharsOfCountry/RulingParty
@onready var foreign_policy_label         = $CharsOfCountry/ForeignPolicy
@onready var economy_policy_label         = $CharsOfCountry/EconomyPolicy
@onready var trade_policy_label           = $CharsOfCountry/TradePolicy
@onready var building_of_factories        = $CharsOfCountry/BuildingFactories
@onready var subsidization_label          = $CharsOfCountry/Subsidization
@onready var cost_of_factories_label      = $CharsOfCountry/CostOfFactories
@onready var cost_of_infrastructure_label = $CharsOfCountry/CostOfInfrastructure
@onready var income_of_capitalists_label  = $CharsOfCountry/IncomeOfCapitalists
@onready var min_tariffs_label            = $CharsOfCountry/MaxTariffs
@onready var max_tariffs_label            = $CharsOfCountry/MinTariffs

@onready var soc_reforms            = $CharsOfCountry/SocReforms
@onready var pol_reforms            = $CharsOfCountry/PolReforms

@onready var radio_net = $Values/radio_net
@onready var revanchism = $Values/revanchism
@onready var pluralism = $Values/pluralism
@onready var military_fatigue = $Values/military_fatigue

var list_of_answers: Dictionary = {true: "Да", false: "Нет"}


func _ready():
	spawn_party_panels()


func spawn_party_panels():
	var political_manager = Players.get_player_client().political_manager
	var list_of_parties = political_manager.parties_list
	for i in list_of_parties:
		var panel = load("res://Objects/Player/Window_parties/Party.tscn").instantiate()
		$ScrollContainer/VBoxContainer.add_child(panel)
		
		panel.party = i
		panel.update()


func update_information():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.update()
	update_information_of_country()
	

func update_information_of_country():
	var player =  Players.get_player_client()
	var ruling_party = player.get_ruling_party()
	
	form_of_goverment_label.text = "Форма правления: " + tr(player.get_government_form().policy_name)
	ruling_party_label.text = ruling_party.party_name
	
	foreign_policy_label.text = "Военная политика: "       + ruling_party.get_military_policy()
	economy_policy_label.text = "Экономическая политика: " + ruling_party.get_economic_policy()
	trade_policy_label.text   = "Торговая политика: "      + ruling_party.get_trade_policy()
	
	#subsidization_label.text = player.
#	cost_of_factories_label.text      = "Цена фабрик: +" + str(player.factory_cost) + "%"
#	cost_of_infrastructure_label.text = "Цена инфраструктуры: +" + str(player.infrastructure_cost) + "%"
#	income_of_capitalists_label.text  = "Доходы капиталистов: " + str(player.income_of_capitalists) + "%"
#	min_tariffs_label.text            = "Минимальные пошлины: " + str(player.min_tariffs) + "%"
#	max_tariffs_label.text            = "Максимальные пошлины: " + str(player.max_tariffs) + "%"
#	subsidization_label.text          = "Cубсидии фабрик: " + list_of_answers[player.subsidization]
#	building_of_factories.text        = "Строительство неприбыльных фабрик: " + list_of_answers[player.building_not_profit_factories]
#
#	soc_reforms.text = "Проведение социальных реформ: "   + str(player.reforms_manager.points_social_reforms)
#	pol_reforms.text = "Проведение политических реформ: " + str(player.reforms_manager.points_political_reforms)
#
#	radio_net.text = "Радиосети: " + str(player.radio_net)
#	revanchism.text = "Реваншизм: " + str(player.revanchism)
#	pluralism.text = "Плюрализм: " + str(player.pluralism)
#	military_fatigue.text = "Военная усталость: " + str(player.military_fatigue)
	

func get_status_of_country(_policy):
	var player = Players.get_player_client()
	status_policy_label.text = "Независимая страна"
	
	if player.satellite != null:
		status_policy_label.text = "Сателлит:" + player.satellite.name_of_country
		
