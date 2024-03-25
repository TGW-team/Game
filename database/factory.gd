class_name DbFactory
extends DbEnterprise

var employed_craftsmen: int = 0
var employed_clerks:    int = 0


func get_free_space():
	return size - (employed_clerks + employed_craftsmen)
	
