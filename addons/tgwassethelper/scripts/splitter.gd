class_name TGWAssetHelperSplitter
extends RefCounted

signal new_completed_region(region: MapRegion)
signal progress_updated(percent: int)
signal done

const BORDER_COLOR: Color = Color.BLACK
const WATER_COLOR: Color = Color("#5bb0ff")
const CROPPED_REGION_COLOR: Color = Color.WHITE
const REGION_LIMIT := 80

class MapRegion:
	var name: String
	var raw_image_data: Image
	var anchor_point: Vector2i
	var anchor_on_atlas: Vector2i
	var points_on_map: Array[Vector2i]
	var size: Vector2i
	var base_color: Color
	var bit_map: BitMap
	var atlas_texture: AtlasTexture
	var node: Node2D
	
	func _notification(what):
		if what == NOTIFICATION_PREDELETE:
			if is_instance_valid(node):
				node.queue_free()
	
var skip_region := MapRegion.new()
var image_data: Array = []
var regions: Array = []
var completed_regions: Array[MapRegion] = []

var _stop = false
var _thread := Thread.new()

var region_index = 0
var cells_operated := 0
var cells_total := 0


func start(new_image: Image):
	_thread.start(_operate.bind(new_image))


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_stop = true
		_thread.wait_to_finish()


func _operate(new_image: Image):
	var origin_size = new_image.get_size()
	cells_total = origin_size.x * origin_size.y
	# Создаем пустой двумерный массив что бы отобразить все клетки
	# весит он мегабайт 600 если полностью забить его рефами. В целом терпимо
	image_data.resize(origin_size.y)
	
	for n in origin_size.y:
		var arr: Array = []
		arr.resize(origin_size.x)
		
		image_data[n] = arr
	
	# Основной цикл сканирования
	# Просто итерируем все пиксели
	for y in range(origin_size.y):
		for x in range(origin_size.x):
			
			# На случай принудительного завершения треда, прерываем цикл и выходим досрочно
			if _stop:
				return
			
			# Проверяем не прошли мы уже эту ячейку ранее
			if image_data[y][x]:
				continue
			
			var current_color = new_image.get_pixel(x, y)
			
			# Если попали на границу или воду, скип
			if current_color.is_equal_approx(BORDER_COLOR):
				# Помечаю ячейку как пройденую
				image_data[y][x] = skip_region
				cells_operated += 1
				continue
			
			# Цвет отличающийся от границы или воды, регистрируем новый регион и стартуем заливку,
			# что бы отметить все пиксели этой зоны
			var new_region = MapRegion.new()
			_filling(x, y, new_region, new_image)
			
			emit_signal(
				"progress_updated", 
				floor(float(cells_operated) / float(cells_total) * 100)
			)
			
			if new_region.points_on_map.size() > REGION_LIMIT:
				
				regions.append(new_region)
				_image_factory()
				
	for completed_region in completed_regions:
		completed_region.points_on_map.clear()
	
	emit_signal("done")


func _filling(x: int, y: int, region: MapRegion, map: Image):
	# Классическое использование заливки подразумевает рекурсию,
	# в годоте же есть ограничение на глубину рекурсии потому я ее избегаю используя цикл и стек
	var stack: Array[Vector2i] = [Vector2i(x, y)]
	var target_color = map.get_pixel(x, y)
	var map_size = map.get_size()

	# Итерируем стек до тех пор пока он не будет пуст
	while true:
		# Текущий элемент из стека - валидный, мы используем его как отправную точку для поиска соседей
		# Отмечаем его как пройденный, маркируя текущим регионом
		var center = stack.pop_back()
		
		if center == null:
			break
		
		image_data[center.y][center.x] = region
		region.points_on_map.append(center)
		cells_operated += 1
		
		# Валидируем соседей и добавляем в стек если валидны
		var siblings = [
			Vector2i(center.x, center.y - 1), # top
			Vector2i(center.x + 1, center.y), # right
			Vector2i(center.x, center.y + 1), # bottom
			Vector2i(center.x - 1, center.y), # left
		]
		
		for sibling in siblings:
			# Проверяем не выходит ли индекс за границы изображения
			if sibling.x < 0 || sibling.x >= map_size.x || sibling.y < 0 || sibling.y >= map_size.y:
				# если выходит, мы просто пропускаем этот элемент, отмечать его не нужно, ведь пикселей за границей изображения нету
				continue
				
			# проверяем не прошли ли мы уже эту клетку
			if image_data[sibling.y][sibling.x]:
				continue
				
			# Если цвет соседа совпал с цветом региона, записываем его в стек
			if map.get_pixel(sibling.x, sibling.y).is_equal_approx(target_color):
				stack.append(Vector2i(sibling.x, sibling.y))
				continue
			
			# отмечаем клетку как пройденную
			image_data[center.y][center.x] = skip_region
			cells_operated += 1

	region.base_color = target_color


func _image_factory():
	while true:
		if _stop:
			break
			
		var region = regions.pop_back()
		
		if !region:
			break
		
		var index = region_index
		region_index += 1
		
		# перед началом создания изображения нужно понять его высоту и ширину
		# получим минимальные и максимальные значения x, y и на их основе посчитаем размер
		var min_point = region.points_on_map[0]
		var max_point = region.points_on_map[0]
		
		for point in region.points_on_map:
			if point.x < min_point.x:
				min_point.x = point.x
			
			if point.x > max_point.x:
				max_point.x = point.x
			
			if point.y < min_point.y:
				min_point.y = point.y
			
			if point.y > max_point.y:
				max_point.y = point.y
		
		# Кроме размера определим еще и якорь (левую верхнюю точку), это пригодится когда надо будет расположить спрайт в мире
		region.anchor_point = min_point
		region.size = max_point - min_point + Vector2i(1, 1)
		
		var image = Image.create(region.size.x, region.size.y, false, Image.FORMAT_RGBA8)
		
		image.fill_rect(
			Rect2i(Vector2i.ZERO, region.size - Vector2i.ONE),
			Color(0.0, 0.0, 0.0, 0.0)
		)
		
		for point_index in range(region.points_on_map.size()):
			region.points_on_map[point_index] = region.points_on_map[point_index] - min_point
			image.set_pixel(region.points_on_map[point_index].x, region.points_on_map[point_index].y, CROPPED_REGION_COLOR)
		
		region.raw_image_data = image
		
		region.name = str(completed_regions.size())
		completed_regions.append(region)
		emit_signal("new_completed_region", region)
