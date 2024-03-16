extends Panel

@onready var factories_list   = $VBoxContainer/GridContainer
@onready var craftsmen_number = $VBoxContainer/HBoxContainer/Label
@onready var clerks_number    = $VBoxContainer/HBoxContainer/Label2

var focused_region: Region


func open_window(region: Region):
	focused_region = region
	visible = true
	clear_list()
	for i in focused_region.factories_list:
		var panel = $FactoryPanel.duplicate()
		factories_list.add_child(panel)
		panel.start(i)


func clear_list():
	for i in factories_list.get_children():
		i.queue_free()


func update_info():
	if focused_region == null:
		return
	
	craftsmen_number.text = str(focused_region.pop_units_list[0].unemployed_quantity)
	clerks_number.text    = str(focused_region.pop_units_list[1].unemployed_quantity)


func close_window():
	visible = false
