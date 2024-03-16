class_name PoliticsManager
extends RefCounted


var parties_list: Array[Party]
var ruling_party: Party
var government_form: GovernmentForm


func set_parties(client):
	var path = "res://resources/parties/ideologies/"
	var dir  = DirAccess.open(path)
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var file = load(path + file_name)
		create_party(file, client)


func create_party(ideology: Ideology, client: Client):
	var party = Party.new(ideology)
	parties_list.append(party)
	
	if client.state_res.starting_ruling_party == ideology:
		ruling_party = party


func set_government(government: GovernmentForm):
	government_form = government
