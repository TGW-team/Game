extends Node


var starting_state: Country
var client_setter

var player:              Client
var date_manager:        DateManager
var consumption_manager: ConsumptionManager


func get_player_client():
	return player.client
