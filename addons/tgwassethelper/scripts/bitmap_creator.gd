class_name TGWAssetHelperBitmapCreator
extends RefCounted

signal bit_map_created(region: TGWAssetHelperSplitter.MapRegion)

var _items: Array[TGWAssetHelperSplitter.MapRegion] = []
var _items_mu:= Mutex.new()
var _new_item_added := Semaphore.new()
var _thread := Thread.new()
var _stop := false


func _init():
	_thread.start(_operate_bitmasks)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_stop = true
		_new_item_added.post()
		_thread.wait_to_finish()


func add_to_process(item: TGWAssetHelperSplitter.MapRegion):
	if _stop:
		return
		
	_items_mu.lock()
	_items.append(item)
	_items_mu.unlock()
	
	if _items.size() == 1:
		_new_item_added.post()


func _operate_bitmasks():
	while true:
		if _stop:
			break
		
		_new_item_added.wait()
		
		while _items.size():
			_items_mu.lock()
			var item := _items.pop_front()
			_items_mu.unlock()
			var bit_map := BitMap.new()
			
			bit_map.create_from_image_alpha(item.raw_image_data)
			item.bit_map = bit_map
			emit_signal("bit_map_created", item)
