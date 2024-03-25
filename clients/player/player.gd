class_name Client
extends Node2D

const speed_of_camera: float    = 1000
const WINDOWS_LIST: Array[String] = ["PoliticsWindow", "BudgetWindow", "RegionWindow", "IndustryWindow", "ProductionWindow", "ResearchWindow"]

@onready var camera          = $Camera

@onready var politics_window = $CanvasLayer/PoliticsWindow
@onready var budget_window   = $CanvasLayer/BudgetWindow
@onready var values_panel    = $CanvasLayer/ValuesPanel
@onready var region_window   = $CanvasLayer/RegionWindow
@onready var industry_window = $CanvasLayer/IndustryWindow
@onready var production_window = $CanvasLayer/ProductionWindow

var polity: DbPolity


func _init():
	SceneStorage.player = self


func _process(delta):
	var pos = camera.get_local_mouse_position()
	if pos[0] < -950:
		camera.position.x -= speed_of_camera * delta
	if pos[0] > 950:
		camera.position.x += speed_of_camera * delta
	if pos[1] < -520:
		camera.position.y -= speed_of_camera * delta
	if pos[1] > 550:
		camera.position.y += speed_of_camera * delta
	#if Input.is_action_pressed("W"):# and position.y >= 1200:
		#camera.position.y -= speed_of_camera * delta
#
	#if Input.is_action_pressed("A"):# and position.x >= 1600:
		#camera.position.x -= speed_of_camera * delta
		#
	#if Input.is_action_pressed("S"):# and position.y <= 2100:
		#camera.position.y += speed_of_camera * delta
		#
	#if Input.is_action_pressed("D"):# and position.x <= 2400:
		#camera.position.x += speed_of_camera * delta


func open_window(window_name):
	var window = get_node("CanvasLayer/" + window_name)
	var window_visible = window.visible
	
	for i in WINDOWS_LIST:
		get_node("CanvasLayer/" + i).visible = false
	
	window.visible = not window_visible
