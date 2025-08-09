extends PanelContainer

signal confirmed(boolean: bool)

@export var text: String

@onready var label: Label = %Label
@onready var confirm_button: Button = %confirmButton
@onready var cancel_button: Button = %cancelButton

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	confirm_button.pressed.connect(_on_button_pressed.bind(true))
	cancel_button.pressed.connect(_on_button_pressed.bind(false))
	
func _on_visibility_changed():
	if visible:
		label.text = text

func _on_button_pressed(boolean: bool):
	hide()
	confirmed.emit(boolean)
