extends PanelContainer

@export var unselectStyleBox: StyleBoxFlat
@export var selectStyleBox: StyleBoxFlat

@onready var texture_rect: TextureRect = $TextureRect

@export var itemResource: Resource

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	_on_focus_exited()
	
	if itemResource.texture:
		texture_rect.texture = itemResource.texture

func _on_focus_entered():
	add_theme_stylebox_override("panel", selectStyleBox)
	
func _on_focus_exited():
	add_theme_stylebox_override("panel", unselectStyleBox)
