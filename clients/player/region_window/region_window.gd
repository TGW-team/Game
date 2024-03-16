extends Panel


@onready var region_name      = $RegionName
@onready var close            = $Close
@onready var cottage_industry = $CottageIndustry
@onready var terr_picture
@onready var pop_number       = $PopStats/PopNumber
@onready var migration        = $PopStats/Migration
@onready var birth_rate       = $PopStats/BirthRate
@onready var industry         = $VBoxContainer2/Button3

@onready var rmc_list         = $RmcList
@onready var produced_goods   = $ProducedGoods
@onready var pop_panels_list  = $Population/VBoxContainer


var focused_region: Region


func close_window():
	visible = false


func region_is_pressed(region: Region):
	visible = true
	focused_region = region
	
	for i in pop_panels_list.get_children():
		i.set_info(region.pop_units_list)
	
	update_info()


func update_info():
	if focused_region == null:
		return
	
	region_name.text = focused_region.region_name
	
	set_pop_stats()
	set_pop_panels()
	set_production_list()
	set_rmc_list()
	

func set_production_list():
	for i in produced_goods.get_children():
		i.queue_free()
	
	for i in focused_region.factories_list:
		var node = TextureRect.new()
		node.texture = i.produced_good.icon
		produced_goods.add_child(node)


func set_rmc_list():
	for i in rmc_list.get_children():
		i.visible = false
	
	var counter = 0
	for i in focused_region.rmc_list:
		rmc_list.get_child(counter).set_rmc(i)
		counter += 1


func set_pop_stats():
	pop_number.text = "Population: " + str(focused_region.get_population_number())
	migration.text  = ""
	birth_rate.text = ""


func set_pop_panels():
	for i in $Population/VBoxContainer.get_children():
		i.update_info()


func open_industry_window():
	SceneStorage.player.industry_window.open_window(focused_region)
