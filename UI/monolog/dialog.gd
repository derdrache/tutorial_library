extends Node

@export_multiline var strings: Array[String] = []

@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var label: Label = %Label

var inTalkRange := false
var tween: Tween
var textLoaded = true
var dialogNumber = 0

func _ready() -> void:
	canvas_layer.hide()

func _input(event: InputEvent) -> void:
	if canvas_layer.visible:
		_dialog_input()
	else:
		_talk_to_input()

func _dialog_input():
	if Input.is_action_just_pressed("ui_accept"):
		if textLoaded:
			_next_dialog()
		else:
			_fast_show()
			
func _next_dialog():
	dialogNumber += 1
	
	if dialogNumber == strings.size():
		_quit_dialog()
	else:
		_start_diaglog()

func _quit_dialog():
	get_tree().paused = false
	dialogNumber = 0
	
	canvas_layer.hide()

func _fast_show():
	tween.kill()
	label.visible_ratio = 1
	textLoaded = true

func _talk_to_input():
	if Input.is_action_just_pressed("interaction") and inTalkRange:
		_start_diaglog()
		
func _start_diaglog():
	canvas_layer.show()
	#get_tree().paused = true
	
	label.visible_ratio = 0
	label.text = strings[dialogNumber]

	_dialog_animation()

func _dialog_animation():
	textLoaded = false

	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, 1)
	
	await tween.finished
	textLoaded = true
	
	
	
	
	
	
	
