@tool
extends EditorPlugin

const MainPanel = preload("res://addons/tgwassethelper/scenes/main_panel_asset_helper.tscn")

var sprite_factory
var main_panel_instance

func _enter_tree():
	add_tool_menu_item("TGW Sprite factory", _on_sprite_factory_activated)
	main_panel_instance = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)



func _exit_tree():
	remove_tool_menu_item("TGW Sprite factory")
	
	if sprite_factory:
		sprite_factory = null
		
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "AssetHelper"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Object", "EditorIcons")


func _on_sprite_factory_activated():
	sprite_factory = load("res://addons/tgwassethelper/scripts/sprite_factory.gd").new()

	var sprite_factory_window: AcceptDialog = load("res://addons/tgwassethelper/scenes/sprite_factory.tscn").instantiate()
	
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
