extends Control

signal power_selected(power: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var power_display: HBoxContainer = %PowerDisplay
@onready var power_label: Label = %PowerLabel

const MAX_POWER = 5

var power: int = 0

func _ready() -> void:
	power_display.hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_power_selected()

func _power_selected():
	animated_sprite_2d.pause()
	
	if power < MAX_POWER:
		power_label.text = str(power)
	else:
		power_label.text = "MAX!"
		
	power_display.show()
	
	power_selected.emit(power)
	
	# video showcase
	await get_tree().create_timer(1.5).timeout
	
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_frame_changed() -> void:
	power = animated_sprite_2d.frame
