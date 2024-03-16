class_name GoodNeed
extends Resource

@export var good:     Good
@export var quantity: float
@export_enum("basic_goods", "everyday_goods", "middle_goods", "luxury_goods") var need_type: String
