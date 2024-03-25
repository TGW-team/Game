class_name TGWAssetHelperTextureCollector
extends RefCounted

signal atlas_anchor_added(region: TGWAssetHelperSplitter.MapRegion)
signal progress_updated(percent: int)
signal done

const image_height = 5000 # Высота картинки
const image_width  = 5000 # Ширина картинки

var sprite_list: Array[TGWAssetHelperSplitter.MapRegion]
var save_path

func start(regions: Array[TGWAssetHelperSplitter.MapRegion], _save_path: String):
	sprite_list = regions
	save_path = _save_path
	
	sort_sprite_list()
	insert_images()


func sort_sprite_list(): # Метод сортировки пузырьками. Сортируем по высоте спрайта
	var list_size = sprite_list.size()

	for i in range(list_size - 1):
		emit_signal(
			"progress_updated", 
			floor(float(i+1) / float(list_size) * 50) 
		)
		for j in range(list_size - i - 1):
			var el_1 := sprite_list[j]
			var el_2 := sprite_list[j + 1]
			
			if el_1.raw_image_data.get_height() < el_2.raw_image_data.get_height():
				swap(el_1, el_2)


func swap(element, next_element):
	var next_element_pos = sprite_list.find(next_element)
	
	sprite_list.erase(element)
	sprite_list.insert(next_element_pos, element)


func insert_images():
	var canvas = create_canvas()
	var left_border = 0
	var up_border   = 0
	var current_level_height = 0
	var sprites_total = sprite_list.size()
	var sprite_list_copy: Array[TGWAssetHelperSplitter.MapRegion] = sprite_list.duplicate() # Копия нужна что бы сохранить оригинальную структуру массива
	
	while sprite_list_copy.size() > 0:
		emit_signal(
			"progress_updated", 
			50 + floor(float(sprite_list_copy.size()) / float(sprites_total) * 50) 
		)
		
		current_level_height = create_new_level(canvas, left_border, up_border, sprite_list_copy).size.y
		up_border = up_border + current_level_height + 1
	
	ResourceSaver.save(ImageTexture.create_from_image(canvas), save_path)
	
	var scan_helper = TGWAssetHelperEditorScan.new()
	scan_helper.start_scan()
	await scan_helper.scan_ended
	
	print("Saved: ", save_path)

	emit_signal("done")


func create_new_level(canvas: Image, left_border: int, up_border: int, sprite_list_copy):
	var highest_sprite = sprite_list_copy[0]
	var current_sprite = sprite_list_copy[0]
	var region_size    = current_sprite.size
	
	var size_sum = region_size.x + left_border + sprite_list_copy[1].size.x
	
	while region_size.x + left_border < image_width and not sprite_list_copy.is_empty():
		
		current_sprite = sprite_list_copy[0]
		region_size    = current_sprite.size
		
		if region_size.x + left_border > image_width:
			return highest_sprite
		
		current_sprite.anchor_on_atlas = Vector2i(left_border + 1, up_border + 1)
		emit_signal("atlas_anchor_added", current_sprite)
		
		insert_picture(canvas, current_sprite.raw_image_data, left_border + 1, up_border + 1)
		left_border = left_border + region_size.x + 1
		sprite_list_copy.pop_front()
		
	return highest_sprite


func create_canvas():
	var canvas = Image.create(image_width, image_height, false, Image.FORMAT_RGBA8)
	canvas.fill_rect( #Заполняем картинку полностью прозрачным цветом
		Rect2i(Vector2i.ZERO, Vector2i(image_width, image_height)),
		Color(0.0, 0.0, 0.0, 0.0)
		)
	return canvas
	

func insert_picture(canvas: Image, region_sprite: Image, left_border: int, up_border: int): # left_border и up_border - отсчет начала пространства, в которое мы будем вставлять спрайт
	canvas.blit_rect(region_sprite, Rect2i(Vector2i.ZERO, region_sprite.get_size()), Vector2i(left_border, up_border))

