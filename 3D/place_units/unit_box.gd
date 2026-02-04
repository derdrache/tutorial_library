@tool
extends PanelContainer

signal pressed(unitResource: unit_resource)

@export var unitResource: unit_resource:
	set(value):
		unitResource = value
		$MarginContainer/TextureRect.texture = value.texture

@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(pressed.emit.bind(unitResource))
