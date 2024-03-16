class_name TGWAssetHelperMapCreator
extends RefCounted

enum {TASK_CREATE, TASK_MODIFY_TEXTURE, TASK_MODIFY_BITMAP, TASK_MODIFY_ATLAS, TASK_SAVE_MAP}

signal tasks_ended # таски закончились
signal task_done(task: Task) # конкретный таск завершен
signal done

var regions: Array[TGWAssetHelperSplitter.MapRegion]
var input_region_script
var output_file_path: String

var _thread := Thread.new()
var _semaphore := Semaphore.new()
var _tasks: Array[Task] = []
var _tasks_mu := Mutex.new()
var _stop := false

var map: Node2D


class Task:
	var region: TGWAssetHelperSplitter.MapRegion
	var data
	var task: int


func _init():
	_thread.start(_operate_map)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_stop = true
		_semaphore.post()
		_thread.wait_to_finish()
		map.queue_free()


func save_map():
	_tasks_mu.lock()
	var t := Task.new()
	t.task = TASK_SAVE_MAP
	_tasks.push_front(t)
	_tasks_mu.unlock()


func add_task(task: Task):
	if _stop:
		return
	
	_tasks_mu.lock()
	if task.task != TASK_MODIFY_ATLAS:
		_tasks.append(task)
	else:
		_tasks.push_front(task)
	_tasks_mu.unlock()
	
	if _tasks.size() == 1:
		_semaphore.post()
	
	
func _operate_map():
	_thread.set_thread_safety_checks_enabled(false)
	map = Node2D.new()
	map.name = "Map"
	map.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD
	
	while true:
		if _stop:
			break
		
		_semaphore.wait()
		
		while _tasks.size():
			_tasks_mu.lock()
			var task: Task = _tasks.pop_back()
			_tasks_mu.unlock()
			
			if task.task == TASK_CREATE:
				var new_region: Node2D = _create_new_region(task.region)
				task.region.node = new_region
				emit_signal("task_done", task)
				
			elif task.task == TASK_MODIFY_TEXTURE:
				task.region.node.get_node("Sprite").texture = task.region.atlas_texture
				task.region.node.get_node("HoverEffect").texture = task.region.atlas_texture
				emit_signal("task_done", task)
			
			elif task.task == TASK_MODIFY_BITMAP:
				if !task.region.node:
					print("cant add bitmap, no region node in region with name ", task.region.name)
				else:
					task.region.node.get_node("Button").texture_click_mask = task.region.bit_map
					
				emit_signal("task_done", task)
				
				# Вариант с использованием AREA, но мне лениво возится с событиями, так что пока баттон
				#var area = task.region.node.get_node("Area")
				#var polygons = task.region.bit_map.opaque_to_polygons(
					#Rect2i(Vector2i.ZERO, task.region.bit_map.get_size())
				#)
				#
				#for polygon in polygons:
					#var collision = CollisionPolygon2D.new()
					#area.add_child(collision)
					#collision.polygon = polygon
					#collision.owner = map
					
					
			elif task.task == TASK_MODIFY_ATLAS:
				if task.region == null:
					for ch in map.get_children():
						ch.get_node("Sprite").texture.atlas = task.data
						ch.get_node("HoverEffect").texture.atlas = task.data
						
			elif task.task == TASK_SAVE_MAP:
				var scene = PackedScene.new()
				var result = scene.pack(map)
				
				if result == OK:
					var error = ResourceSaver.save(scene, output_file_path) 
					if error != OK:
						print("An error occurred while saving the scene to disk.")
				else:
					print("An error occurred while pack a map scene")

				emit_signal("done")
				
				
		emit_signal("tasks_ended")


func _create_new_region(region: TGWAssetHelperSplitter.MapRegion):
	var root = Node2D.new()
	root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	root.position = region.anchor_point
	root.name = str("Region", region.name)
	root.set_script(input_region_script)
	root.region_id = str(region.name)
	map.add_child(root)
	root.owner = map
	
	var region_sprite = Sprite2D.new()
	region_sprite.name = "Sprite"
	region_sprite.modulate = region.base_color
	region_sprite.centered = false
	root.add_child(region_sprite)
	region_sprite.owner = map
	
	var region_hover_effect = Sprite2D.new()
	region_hover_effect.name = "HoverEffect"
	region_hover_effect.centered = false
	region_hover_effect.modulate = Color("#0000006d")
	region_hover_effect.hide()
	root.add_child(region_hover_effect)
	region_hover_effect.owner = map
	
	var region_button = TextureButton.new()
	region_button.name = "Button"
	root.add_child(region_button)
	region_button.owner = map
	
	return root
