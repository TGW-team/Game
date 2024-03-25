class_name PolitiesSpawnerManager
extends RefCounted

func create_polity(country: Country):
	var polity = DbPolity.new()
	polity.country     = country
	polity.polity_name = country.country_name
	set_parties(polity)
	set_government(polity)
	return polity


func set_parties(polity: DbPolity):
	var path = "res://resources/parties/ideologies/"
	var dir  = DirAccess.open(path)
	var file_names = dir.get_files()
	
	for file_name in file_names:
		var file = load(path + file_name)
		create_party(file, polity)


func create_party(ideology: Ideology, polity: DbPolity):
	var party = DbParty.new(ideology)
	polity.parties_list.append(party)
	
	if polity.country.starting_ruling_party == ideology:
		party.is_ruling_party = true


func set_government(polity: DbPolity):
	polity.government = polity.country.starting_government
