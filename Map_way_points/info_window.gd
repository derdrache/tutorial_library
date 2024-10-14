extends TextureRect

@export var title: String:
	set(newTitle):
		title = newTitle
		titleLabel.text = newTitle
		
@onready var titleLabel: Label = %title

func _ready() -> void:
	hide()
	_set_signals()
	
func _set_signals() -> void:
	for waypoint in get_tree().get_nodes_in_group("map_way_points"):
		waypoint.pressed.connect(_set_window)
		
func _set_window(newTitle):
	title = newTitle
	show()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		var mousePosition = get_global_mouse_position()
		var mouseOnWindow = get_global_rect().has_point(mousePosition)
		
		if not mouseOnWindow: hide()
