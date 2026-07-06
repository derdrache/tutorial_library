extends PanelContainer

@onready var level_label: Label = %levelLabel
@onready var icon: TextureRect = $MarginContainer/VBoxContainer/icon

const CHECK = preload("uid://dbnvm4tb1ss3y")
const PADLOCK = preload("uid://cganrn6vdthrl")

var levelNumber: int = -1:
	set(value):
		levelNumber = value
		%levelLabel.text = str(value)

func set_lock():
	icon.modulate.a = 1
	icon.texture = PADLOCK
	
func set_open():
	icon.modulate.a = 0

func set_done():
	icon.modulate.a = 1
	icon.texture = CHECK
