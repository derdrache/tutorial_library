@tool
extends Area2D

signal selected(pawn)

@export var color : GameManager.COLORS = GameManager.COLORS.NOTHING:
	set(value):
		color = value
		_set_color()
		
@export var active = false:
	set(value):
		active = value
		
		if not is_node_ready():
			await ready
			
		if value:
			$Sprite.material.set_shader_parameter("thickness", 6)
		else:
			$Sprite.material.set_shader_parameter("thickness", 0)

var currentField

const BLUE = preload("uid://dti3wv0l1bcxr")
const GREEN = preload("uid://d1166csd8uoei")
const RED = preload("uid://bc3xgml3c2lex")
const YELLOW = preload("uid://55p55ndt0vs4")

func _ready() -> void:
	add_to_group("pawn")

func _set_color():
	match color:
		GameManager.COLORS.RED: $Sprite.texture = RED
		GameManager.COLORS.GREEN: $Sprite.texture = GREEN
		GameManager.COLORS.BLUE: $Sprite.texture = BLUE
		GameManager.COLORS.YELLOW: $Sprite.texture = YELLOW


func _on_area_entered(area: Area2D) -> void:
	currentField = area


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not active: return
	
	if event.is_action_pressed("leftClick"):
		selected.emit(self)
