extends HBoxContainer

@onready var progress_bar = $VBoxContainer/ProgressBar
@onready var good_icon    = $GoodIcon
@onready var output       = $VBoxContainer/Label2

var focused_rmc: RMC


func set_rmc(rmc: RMC):
	focused_rmc = rmc
	visible     = true
	update_info()


func update_info():
	if focused_rmc == null:
		return
	
	good_icon.texture = focused_rmc.produced_good.icon
	
	progress_bar.max_value = focused_rmc.size
	progress_bar.value     = focused_rmc.employed_labourers
	output.text            = str(focused_rmc.produced_good_number)#str(focused_rmc.get_profit())
