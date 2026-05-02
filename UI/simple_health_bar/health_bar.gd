extends ProgressBar

func _ready() -> void:
	## only for showcase
	set_health_bar(100, 100)

func _input(_event: InputEvent) -> void:
	## only for showcase
	if Input.is_action_just_pressed("ui_left"):
		get_damage(10)
	elif Input.is_action_just_pressed("ui_right"):
		get_heal(10)


func set_health_bar(currentValue, maxValue):
	maxValue = maxValue
	value = currentValue

func get_damage(damage):
	value -= damage
	
	if value < 0:
		value = 0

func get_heal(heal):
	value += heal
	
	if value > max_value:
		value = max_value
