extends Node


var starting_state: State
var client_setter

var player:              Player
var date_manager:        DateManager
var consumption_manager: ConsumptionManager


func get_player_client():
	return player.client
