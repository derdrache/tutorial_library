extends TextureButton

const SPEED_FULL = preload("res://speed_full.png")
const SPEED_LOW = preload("res://speed_low.png")
const SPEED_MID = preload("res://speed_mid.png")

var currentBattleSpeed = 1

func _ready() -> void:
	pressed.connect(_change_battle_speed)

func _change_battle_speed():
	match currentBattleSpeed:
		1: currentBattleSpeed = 2
		2: currentBattleSpeed = 3
		3: currentBattleSpeed = 1
	
	Engine.time_scale = currentBattleSpeed
	
	_change_icon()
	
func _change_icon():
	var texture
	match currentBattleSpeed:
		1: texture = SPEED_LOW
		2: texture = SPEED_MID
		3: texture = SPEED_FULL
	
	
	texture_normal = texture
	texture_pressed = texture
	texture_hover = texture
	texture_disabled = texture
	texture_focused = texture

func _exit_tree() -> void:
	Engine.time_scale = 1
