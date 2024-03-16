extends Camera2D


const MAX_zoom:        float          = 7.0
const MIN_zoom:        float          = 1.0
const ZOOM_SPEED:      float          = 0.1


func _input(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if zoom.x - ZOOM_SPEED >= MIN_zoom:
			zoom -= Vector2(ZOOM_SPEED, ZOOM_SPEED)
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if zoom.x + ZOOM_SPEED <= MAX_zoom:
			zoom += Vector2(ZOOM_SPEED, ZOOM_SPEED)
