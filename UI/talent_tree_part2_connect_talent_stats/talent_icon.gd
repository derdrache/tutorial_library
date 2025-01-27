@tool
extends PanelContainer

@export var talentResource : TalentResource:
	set(newValue):
		talentResource = newValue
		
		if not Engine.is_editor_hint(): return
		
		if newValue == null: 
			add_theme_stylebox_override("panel", StyleBoxEmpty.new())
			texture_rect.texture = null
		else: 
			add_theme_stylebox_override("panel", TALENT_ICON_STYLEBOX)
			texture_rect.texture = talentResource.talentIcon

@export var lockColorBorder: Color
@export var unlockColorBorder : Color

@onready var texture_rect: TextureRect = $TextureRect

const TALENT_ICON_STYLE = preload("res://talent_icon_style.tres")

func _ready():	
	if not talentResource: 
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		return
	
	add_to_group("talents")
	texture_rect.texture = talentResource.talentIcon
	
	add_theme_stylebox_override("panel", TALENT_ICON_STYLE)
	
	_set_style()
		
func get_center():
	return custom_minimum_size/2

func _set_style():
	var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	
	if talentResource.is_unlocked:
		styleBox.border_color = unlockColorBorder
	else:
		styleBox.border_color = lockColorBorder	
	
	add_theme_stylebox_override("panel", styleBox)
	
func _unlock_talent():
	talentResource.is_unlocked = true
	_set_style()

func _on_button_pressed() -> void:
	_unlock_talent()
