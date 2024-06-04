extends Control

@export var quest_target_position: Vector2

@onready var texture_rect = $TextureRect

const ARROW = preload("res://assets/ui/icons/arrow.png")
const CROSS = preload("res://assets/ui/icons/cross.png")

var camera_zoom 

func _ready():
	camera_zoom = get_viewport().get_camera_2d().zoom

func _process(delta):
	if quest_target_position == Vector2.ZERO: return
	
	var quest_target_screen_position = (quest_target_position - _get_camera_rect().position) * camera_zoom
	
	if _target_on_screen():
		texture_rect.texture = CROSS
		rotation = 0
		global_position = quest_target_screen_position
	else: 
		texture_rect.texture = ARROW
		
		_set_screen_position(quest_target_screen_position)
		_rotate_to_target()
	
	
func _get_camera_rect():
	var pos = get_viewport().get_camera_2d().get_screen_center_position()
	
	var screen_size = get_viewport_rect().size / camera_zoom
	
	return Rect2(pos - screen_size / 2, screen_size)
	
func _target_on_screen():
	return _get_camera_rect().has_point(quest_target_position)
	
func _set_screen_position(screen_target_position):
	var screen_size = get_viewport_rect().size
	var borderOffSet = 50
	var target_position = screen_target_position
	
	if target_position.x < borderOffSet:
		target_position.x = borderOffSet
	if target_position.x > screen_size.x - borderOffSet:
		target_position.x = screen_size.x - borderOffSet
	if target_position.y < borderOffSet:
		target_position.y = borderOffSet
	if target_position.y > screen_size.y - borderOffSet:
		target_position.y = screen_size.y - borderOffSet	
	
	global_position = target_position
	
func _rotate_to_target():
	var current_position = get_viewport().get_camera_2d().get_screen_center_position()
	var direction = (quest_target_position - current_position).normalized()
	
	rotation = direction.angle()
	
	
	
	
	
	
	
	
		
