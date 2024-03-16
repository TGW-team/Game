extends Panel

@onready var demonstrational_party_panel = $ScrollContainer/PartiesList/PartyPanel
@onready var parties_list                = $ScrollContainer/PartiesList
@onready var government                  = $Government
@onready var ruling_party                = $RulingParty


func update_info():
	government.text   = SceneStorage.get_player_client().politics_manager.government_form.government_name
	ruling_party.text = SceneStorage.get_player_client().politics_manager.ruling_party.party_name


func update_party_list():
	for party in SceneStorage.player.client.politics_manager.parties_list:
		create_party_panel(party)


func create_party_panel(party: Party):
	var panel = demonstrational_party_panel.duplicate()
	panel.set_info(party)
	parties_list.add_child(panel)
