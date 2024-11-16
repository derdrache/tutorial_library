extends Control

@export var initalPage := 1

@onready var pages: MarginContainer = %Pages
@onready var buttons: HBoxContainer = %Buttons

func _ready():
	_set_page(initalPage)
	
	for button in buttons.get_children():
		var buttonIndex = button.get_index()
		button.pressed.connect(_set_page.bind(buttonIndex))

func _set_page(pageNumber):
	for i in pages.get_child_count():
		pages.get_children()[i].visible = i == pageNumber
