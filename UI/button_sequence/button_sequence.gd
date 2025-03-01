extends CanvasLayer

signal finished(boolean: bool)

@onready var button_box: HBoxContainer = %buttonBox
@onready var time_label: Label = %timeLabel
@onready var success_label: Label = %successLabel
@onready var timer: Timer = %Timer

var buttonSelection = [
	{"action": "circle", "icon": preload("res://assets/buttons/Button - PS Circle 1.png")},
	{"action": "cross", "icon": preload("res://assets/buttons/Button - PS Cross 1.png")},
	{"action": "square", "icon": preload("res://assets/buttons/Button - PS Square 1.png")},
	{"action": "triangle", "icon": preload("res://assets/buttons/Button - PS Triangle 1.png")},
	{"action": "L1", "icon": preload("res://assets/buttons/Button - PS L1 – 2.png")},
	{"action": "R1", "icon": preload("res://assets/buttons/Button - PS R1 – 2.png")},
	{"action": "ui_down", "icon": preload("res://assets/buttons/arrow_down.png")},
	{"action": "ui_left", "icon": preload("res://assets/buttons/arrow_left.png")},
	{"action": "ui_right", "icon": preload("res://assets/buttons/arrow_right.png")},
	{"action": "ui_up", "icon": preload("res://assets/buttons/arrow_up.png")}
]

var actionSequence = []
var sequenceIndex = 0

func _ready() -> void:
	get_tree().paused = true
	success_label.hide()
	_set_random_sequence()
	
func _set_random_sequence() -> void:
	for node in button_box.get_children():
		var randomPick = buttonSelection.pick_random()
		node.texture = randomPick.icon
		actionSequence.append(randomPick.action)

func _input(event: InputEvent) -> void:
	if not timer.time_left: return
	if not event is InputEventKey or not event.is_pressed(): return

	if Input.is_action_just_pressed(actionSequence[sequenceIndex]):
		_next_index()
	else:
		_reset_all()

func _next_index() -> void:
	button_box.get_child(sequenceIndex).modulate.a = 0
	
	sequenceIndex += 1
	
	if sequenceIndex >= actionSequence.size(): 
		timer.paused = true
		_on_timer_timeout()
		

func _reset_all() -> void:
	sequenceIndex = 0
	
	for node in button_box.get_children():
		node.modulate.a = 1


func _process(delta: float) -> void:
	var remainingTime = snapped(timer.time_left, 0.01)
	time_label.text = str(remainingTime)

func _on_timer_timeout() -> void:
	var success = timer.time_left

	_update_success_label(success)
	
	get_tree().paused = false
	
	finished.emit(success)

func _update_success_label(success: bool) -> void:
	success_label.show()

	if success:
		success_label.text = "SUCCESS"
		success_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		success_label.text = "FAIL"
		success_label.add_theme_color_override("font_color", Color.RED)
