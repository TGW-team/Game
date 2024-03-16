class_name DateManager
extends Timer


var day   = 1
var month = 1
var year  = 1901


var game_is_continue: bool = true
var tick: float = 0.5


func _ready():
	SceneStorage.date_manager = self
	connect("timeout", new_day)


func new_day():
	if game_is_continue:
		change_date()
		GlobalMainLoop.new_day_loop()


func change_date():
	day += 1
	
	if day > 31:
		day = 1
		month += 1
		
		if month > 12:
			month = 1
			year += 1
