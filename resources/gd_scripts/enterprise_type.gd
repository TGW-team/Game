class_name EnterpriseType
extends Resource


@export var enterprise_name: String = ""
@export var produced_good:   Good
@export_enum(
	"metallurgy",
	"vehicle_industry",
	"electric_industry",
	"weapon_industry",
	"chemical_industry",
	"agriculture",
	"rubber_growing",
	"light_industry",
	"machinery_industry",
	"consumer_industry"
	) var production_type: String

@export var basic_production_eff: float = 1.0
@export var raw_materials_list:   Array[StorageGoodRes]
