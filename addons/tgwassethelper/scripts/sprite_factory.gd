extends RefCounted

signal progress_updated(progress: float)

var dialog: AcceptDialog

var input_file_name: String 
var output_map_file_name: String
var output_scene_file_name: String 
var input_region_script: String
var threads_to_clean: Array[Thread]

var progress_steps := 2
var progress_bar: ProgressBar
var splitter: TGWAssetHelperSplitter
var collector: TGWAssetHelperTextureCollector
var atlas_creator: TGWAssetHelperAtlasCreator
var bitmap_creator: TGWAssetHelperBitmapCreator
var map_creator: TGWAssetHelperMapCreator


func configure(_dialog: AcceptDialog):
	dialog = _dialog
	dialog.add_cancel_button("Close")
	dialog.confirmed.connect(_on_build_pressed)
	dialog.canceled.connect(_on_cancel_pressed)
	_setup_progress_bar.call_deferred()


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(dialog):
			dialog.queue_free()
		
		for thread in threads_to_clean:
			thread.wait_to_finish()


func _setup_progress_bar():
	progress_bar = dialog.get_node("SpriteFactory/%ProgressBar")


func _on_build_pressed():
	input_file_name = dialog.get_node("SpriteFactory/%InputReferenceName").text
	output_map_file_name = dialog.get_node("SpriteFactory/%OutputMapName").text
	output_scene_file_name = dialog.get_node("SpriteFactory/%OutputSceneName").text
	input_region_script = dialog.get_node("SpriteFactory/%InputRegionScript").text
	
	atlas_creator = load("res://addons/tgwassethelper/scripts/atlas_creator.gd").new()
	atlas_creator.atlas_texture_created.connect(
		func(region: TGWAssetHelperSplitter.MapRegion):
			var task = TGWAssetHelperMapCreator.Task.new()
			task.region = region
			task.task = map_creator.TASK_MODIFY_TEXTURE
			map_creator.add_task(task)
	)
	
	bitmap_creator = load("res://addons/tgwassethelper/scripts/bitmap_creator.gd").new()
	bitmap_creator.bit_map_created.connect(
		func(region: TGWAssetHelperSplitter.MapRegion):
			var task = TGWAssetHelperMapCreator.Task.new()
			task.region = region
			task.task = map_creator.TASK_MODIFY_BITMAP
			map_creator.add_task(task)
	)
	
	map_creator = load("res://addons/tgwassethelper/scripts/map_creator.gd").new()
	map_creator.input_region_script = load(str("res://", input_region_script))
	map_creator.output_file_path = str("res://", output_scene_file_name)
	map_creator.task_done.connect(
		func(task): 
			if task.task == map_creator.TASK_CREATE:
				bitmap_creator.add_to_process(task.region)
	)
	
	_run_splitter()


func _run_splitter():
	splitter = load("res://addons/tgwassethelper/scripts/splitter.gd").new()
	splitter.progress_updated.connect(_on_splitter_progress_update)
	splitter.done.connect(_on_splitter_done)
	splitter.new_completed_region.connect(
		func(region):
			var task = TGWAssetHelperMapCreator.Task.new()
			task.region = region
			task.task = map_creator.TASK_CREATE
			map_creator.add_task(task)
	)
	
	var input_texture: Texture2D = load(str("res://", input_file_name))
	var thread = Thread.new()
	thread.start(splitter.start.bind(input_texture.get_image()))
	threads_to_clean.append(thread)


func _run_collector():
	collector = load("res://addons/tgwassethelper/scripts/texture_collector.gd").new()
	collector.progress_updated.connect(_on_collector_progress_update)
	collector.done.connect(_on_collector_done)
	collector.atlas_anchor_added.connect(_on_atlas_anchor_added)
	
	var thread = Thread.new()
	thread.start(collector.start.bind(splitter.completed_regions, str("res://", output_map_file_name)))
	threads_to_clean.append(thread)


func _on_cancel_pressed():
	if splitter:
		splitter.process_done = true
		splitter.progress_updated.disconnect(_on_splitter_progress_update)
		splitter.done.disconnect(_on_splitter_done)
		
	dialog.queue_free()


func _on_splitter_done():
	_run_collector()


func _on_collector_done():
	var atlas = load(str("res://", output_map_file_name))
	var task = TGWAssetHelperMapCreator.Task.new()
	task.data = atlas
	task.task = map_creator.TASK_MODIFY_ATLAS
	map_creator.add_task(task)
	
	map_creator.save_map()
	await map_creator.done
	print("Saved: ", str("res://", output_scene_file_name))
	print("All done")


func _on_atlas_anchor_added(region: TGWAssetHelperSplitter.MapRegion):
	atlas_creator.add_to_process(region)


func _on_splitter_progress_update(progress: int):
	_on_progress_update(progress, 1)


func _on_collector_progress_update(progress: int):
	_on_progress_update(progress, 2)


func _on_progress_update(progress: int, current_step: int):
	_update_progress_bar_on_step(progress, current_step, progress_steps)


func _update_progress_bar_on_step(progress: int, step: int, step_total: int):
	emit_signal("progress_updated", float(step - 1) / float(step_total) + float(progress) * float(step) / float(step_total))
