extends TextureRect

@export var title: String

@onready var titleLabel: Label = %title

var scene_dict = {
	0: load("res://tutorial_collection/Map_Fast_Travel/city.tscn"),
	1: load("res://tutorial_collection/Map_Fast_Travel/jungle_scene.tscn")
}
var fastTravelSceneNumber: int

func _ready() -> void:
	hide()
	_set_signals()
	
func _set_signals() -> void:
	for waypoint in get_tree().get_nodes_in_group("map_way_points"):
		waypoint.pressed.connect(_set_window)
		
func _set_window(newTitle, sceneNumber):
	title = newTitle
	titleLabel.text = newTitle
	fastTravelSceneNumber = sceneNumber
	show()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		var mousePosition = get_global_mouse_position()
		var mouseOnWindow = get_global_rect().has_point(mousePosition)
		
		if not mouseOnWindow: hide()


func _on_fast_travel_button_pressed() -> void:
	var scene = scene_dict[fastTravelSceneNumber].instantiate()
	scene.onFastTravel = true
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
