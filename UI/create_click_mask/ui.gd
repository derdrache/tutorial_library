extends Control

@onready var label: Label = $Label

func _ready() -> void:
	label.hide()

func _on_texture_button_pressed() -> void:
	label.show()
	
	await get_tree().create_timer(0.5).timeout
	
	label.hide()
