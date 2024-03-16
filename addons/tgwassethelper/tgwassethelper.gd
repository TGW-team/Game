@tool
extends EditorPlugin

var sprite_factory


func _enter_tree():
	add_tool_menu_item("TGW Sprite factory", _on_sprite_factory_activated)
	pass


func _exit_tree():
	remove_tool_menu_item("TGW Sprite factory")
	
	if sprite_factory:
		sprite_factory = null


func _on_sprite_factory_activated():
	sprite_factory = load("res://addons/tgwassethelper/scripts/sprite_factory.gd").new()

	var sprite_factory_window: AcceptDialog = load("res://addons/tgwassethelper/sprite_factory.tscn").instantiate()
	
	# Эта конструкция нужна что бы не накапливать call_deferred спамом из тредов
	var last_value = 0
	var stop = false
	
	sprite_factory.progress_updated.connect(
		func(val):
			last_value = val
			if !stop:
				Callable(
					func(): 
						stop = false
						sprite_factory_window.get_node("SpriteFactory/%ProgressBar").value = last_value
				).call_deferred()
	)
	
	sprite_factory.configure(sprite_factory_window)
	EditorInterface.popup_dialog_centered(sprite_factory_window, Vector2i(400, 600))

