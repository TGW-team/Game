class_name DbRMC
extends DbEnterprise


var employed_labourers: int = 0


func get_free_space():
	return size - employed_labourers
