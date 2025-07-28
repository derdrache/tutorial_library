extends Control

@export var animationDuration := 0.5

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var progress_bar_label: Label = %progressBarLabel
@onready var combo_label: Label = %comboLabel

var letterArray = ["C", "B", "A", "S"]
var comboUpArray = [10, 15, 25, 50]

var maxCombo: int
var currentAnimationValue: float

func _ready() -> void:
	progress_bar_label.text = letterArray[0]
	texture_progress_bar.max_value = comboUpArray[0]

func _process(delta: float) -> void:	
	if currentAnimationValue > 0:
		_refresh_meter(delta)

func _refresh_meter(delta):
	var timeValue = _get_time_value(delta)
	
	texture_progress_bar.value += timeValue
	currentAnimationValue -= timeValue
	
	var fullBar = texture_progress_bar.value == texture_progress_bar.max_value 
	var lastIndex = progress_bar_label.text == letterArray[-1]
	
	if fullBar and not lastIndex:
		var last = _set_next_level()
	elif fullBar and lastIndex:
		currentAnimationValue = 0

func _get_time_value(delta):
	var time = animationDuration / delta
	var value = texture_progress_bar.max_value / time
	
	value = snapped(value, texture_progress_bar.step)

	if value > currentAnimationValue:
		value = currentAnimationValue
		
	return value

func _set_next_level():
	texture_progress_bar.value = 0
	
	var currentIndex = letterArray.find(progress_bar_label.text)
	var letterIndex = clamp(currentIndex + 1, 0, comboUpArray.size() - 1)
		
	progress_bar_label.text = letterArray[letterIndex]

	if letterIndex < comboUpArray.size():
		texture_progress_bar.max_value = comboUpArray[letterIndex]


func update_combo(value: int):
	if value > maxCombo:
		currentAnimationValue = value - maxCombo
		maxCombo = value
		combo_label.text = str(maxCombo)
