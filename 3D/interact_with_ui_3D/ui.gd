extends Control

signal code_entered(code: int)

@onready var line_edit: LineEdit = %LineEdit
@onready var grid_container: GridContainer = %GridContainer

var enteredCode = ""

func _ready() -> void:
	for button in grid_container.get_children():
		button.pressed.connect(_on_button_pressed.bind(button.name))
		
func _on_button_pressed(name):
	if name.is_valid_int():
		enteredCode += name
		line_edit.text = enteredCode
	elif name == "Enter":
		_send_code()
	elif name == "Reset":
		enteredCode = ""
		line_edit.text = ""

func _send_code():
	code_entered.emit(enteredCode.to_int())
	enteredCode = ""
	line_edit.text = ""
