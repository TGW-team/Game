class_name TGWAssetHelperAtlasCreator
extends RefCounted

signal atlas_texture_created(region: TGWAssetHelperSplitter.MapRegion)
signal done


var regions: Array[TGWAssetHelperSplitter.MapRegion]
var _thread := Thread.new()
var _semaphore := Semaphore.new()
var _regions: Array[TGWAssetHelperSplitter.MapRegion] = []
var _regions_mu := Mutex.new()
var _stop := false


func _init():
	_thread.start(_operate_atlas)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_stop = true
		_semaphore.post()
		_thread.wait_to_finish()


func add_to_process(item: TGWAssetHelperSplitter.MapRegion):
	if _stop:
		return
		
	_regions_mu.lock()
	_regions.append(item)
	_regions_mu.unlock()
	
	if _regions.size() == 1:
		_semaphore.post()


func _operate_atlas():
	while true:
		if _stop:
			break
		
		_semaphore.wait()
		
		while _regions.size():
			_regions_mu.lock()
			var region := _regions.pop_front()
			_regions_mu.unlock()
			
			var atlas_texture := AtlasTexture.new()
			atlas_texture.region = Rect2i(region.anchor_on_atlas, region.size)
			region.atlas_texture = atlas_texture
			emit_signal("atlas_texture_created", region)
			
	emit_signal("done")
