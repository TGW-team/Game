class_name ProductionEffManager
extends RefCounted


var factories_efficiency: float = 0.0
var rmc_efficiency:       float = 0.0

var production_efficiency: Dictionary = {
	"metallurgy":         0.0,
	"vehicle_industry":   0.0,
	"electric_industry":  0.0,
	"weapon_industry":    0.0,
	"chemical_industry":  0.0,
	"agriculture":        0.0,
	"rubber_growing":     0.0,
	"light_industry":     0.0,
	"consumer_industry":  0.0,
	"machinery_industry": 0.0,
}
