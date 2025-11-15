extends Control

signal move_selected()
signal attack_selected()

@onready var attack_button: Button = %attackButton
@onready var move_button: Button = %moveButton

func _ready() -> void:
	add_to_group("option_menu")
	
	hide()

	_set_signals()
	
func _set_signals():
	for playerCharacter in get_tree().get_nodes_in_group("player"):
		playerCharacter.character_selected.connect(_set_visible.bind(true))
		
	attack_button.pressed.connect(attack_selected.emit)
	move_button.pressed.connect(move_selected.emit)
	
func _set_visible(_movement, boolean:bool):
	visible = boolean
