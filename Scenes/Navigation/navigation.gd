extends Node

signal thread_cteate_polygons_done

export(NodePath) var tile_container_np

const CHECKER_GROW_SIZE = Vector2(25, 25)
var CollideCollector = preload("res://Scenes/Navigation/collide_collector.gd")

var _tiles = []
var _tiles_mu = Mutex.new()
var _physics_space
var _threads = []
var _collisions_collection_node
var _navigation_checker_area_script = preload("res://Scenes/Navigation/navigation_checker_area.gd")
var _close = false
var _close_mu = Mutex.new()
var _collectors = []
var _collectors_mu = Mutex.new()
var _thread_cteate_polygons_done_counter = 0

func _ready():
	return
	_create_thread_pool()
	var _err = connect("thread_cteate_polygons_done", self, "_on_thread_cteate_polygons_done")
	_physics_space = Physics2DServer.space_create()
	Physics2DServer.space_set_active(_physics_space, true)
	
	var container = get_node(tile_container_np)
	_collisions_collection_node = container.get_node("DebugCollisionView")

	for ch in container.get_children():
		if ch is TextureButton:
			_tiles.append(ch)

	for t in _threads:
		t.start(self, "_cteate_polygons")


func _exit_tree():
	_close_mu.lock()
	_close = true
	_close_mu.unlock()
	
	for t in _threads:
		t.wait_to_finish()


func _cteate_polygons():
	while true:
		if _ckeck_close():
			return
		
		var tile = _get_next(_tiles, _tiles_mu)
		
		if tile == null:
			emit_signal("thread_cteate_polygons_done")
			return
		
		var raw_image = tile.texture_normal.get_data() as Image
		
		var bm = BitMap.new()
		bm.create_from_image_alpha(raw_image)
		
		var polygons = bm.opaque_to_polygons(Rect2(Vector2.ZERO, bm.get_size()))
		var tile_area = Area2D.new()
		tile_area.set_script(_navigation_checker_area_script)
		tile_area.tile = tile
		
		Physics2DServer.area_set_transform(tile_area, Transform2D(0, tile.rect_global_position))
		Physics2DServer.area_set_collision_layer(tile_area, 1)
		Physics2DServer.area_set_collision_mask(tile_area, 0)
		Physics2DServer.area_set_monitorable(tile_area, true)
		Physics2DServer.area_set_space(tile_area, _physics_space)
		
		for poly in polygons:
			var shape = Physics2DServer.convex_polygon_shape_create()
			Physics2DServer.shape_set_data(shape, poly)
			Physics2DServer.area_add_shape(tile_area, shape)
		
		var collector = CollideCollector.new()
		collector.tile = tile
		
		var s = raw_image.get_size()
		raw_image.resize(s.x + CHECKER_GROW_SIZE.x, s.y + CHECKER_GROW_SIZE.y, Image.INTERPOLATE_NEAREST)
		bm.create_from_image_alpha(raw_image)
		polygons = bm.opaque_to_polygons(Rect2(Vector2.ZERO, bm.get_size()))
		for poly in polygons:
			var shape = Physics2DServer.convex_polygon_shape_create()
			Physics2DServer.shape_set_data(shape, poly)
			collector.detector_shapes.append(shape)
		
		_add_new_collector(collector)


func _monitor_collisions():
	while true:
		if _ckeck_close():
			return
		
		var collector = _get_next(_collectors, _collectors_mu)
		
		if collector == null:
			break
		
		var direct_space_state := Physics2DServer.space_get_direct_state(_physics_space)
		
		for shape in collector.detector_shapes:
			var query = Physics2DShapeQueryParameters.new()
			query.collide_with_areas = true
			query.collide_with_bodies = false
			query.collision_layer = 1
			query.shape_rid = shape
			query.transform = Transform2D(0, collector.tile.rect_global_position - CHECKER_GROW_SIZE / 2)
			var res = direct_space_state.intersect_shape(query)
			for r in res:
				if r.collider.tile != collector.tile:
					collector.tile.call_deferred("add_debug_nav_line",  r.collider.tile)


func _create_thread_pool():
	var processors = OS.get_processor_count() - 1
	
	for _i in processors:
		_threads.append(Thread.new())


func _ckeck_close():
	var result
	
	_close_mu.lock()
	result = _close
	_close_mu.unlock()
	
	return result


func _get_next(arr, mu):
	var result
	mu.lock()
	result = arr.pop_back()
	mu.unlock()
	return result


func _add_new_collector(collector):
	_collectors_mu.lock()
	_collectors.append(collector)
	_collectors_mu.unlock()


func _on_thread_cteate_polygons_done():
	_thread_cteate_polygons_done_counter += 1
	
	if _thread_cteate_polygons_done_counter == _threads.size():
		yield(get_tree(), "physics_frame")
		_monitor_collisions()
