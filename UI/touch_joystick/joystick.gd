extends Control

@onready var border: PanelContainer = $Border
@onready var point: PanelContainer = $Point

var joystickDirection := Vector2.ZERO
var lastDirectionActions: Array = []

func _input(event: InputEvent) -> void:
	var centerPosition = global_position + size / 2 - point.size / 2
	
	if event is InputEventScreenDrag:
		var onLeftScreen = event.position.x < get_viewport_rect().size.x / 2
		
		if not onLeftScreen: 
			return
		
		var newPosition = event.position

		var radius = border.size.x / 2
		var inBorder = centerPosition.distance_to(newPosition) < radius
		var direction = centerPosition.direction_to(newPosition)
		
		if inBorder:
			point.global_position = newPosition
		else:
			point.global_position = centerPosition + direction * radius
		
		joystickDirection = direction

	var isTouchReleased = event is InputEventScreenTouch and event.is_released()
	if isTouchReleased:
		point.global_position = centerPosition
		joystickDirection = Vector2.ZERO

func get_joystick_direction():
	return joystickDirection

func _physics_process(_delta: float) -> void:	
	if not joystickDirection: 
		for action in lastDirectionActions:
			Input.action_release(action)
		return
	
	if joystickDirection.x > 0.5:
		Input.action_press("ui_right")
		lastDirectionActions.append("ui_right")
	else:
		_release_action("ui_right")
		
	if joystickDirection.x < -0.5:
		Input.action_press("ui_left")
		lastDirectionActions.append("ui_left")
	else:
		_release_action("ui_left")
		
	if joystickDirection.y > 0.5:
		Input.action_press("ui_down")
		lastDirectionActions.append("ui_down")
	else:
		_release_action("ui_down")
		
	if joystickDirection.y < -0.5:
		Input.action_press("ui_up")
		lastDirectionActions.append("ui_up")
	else:
		_release_action("ui_up")

func _release_action(action: StringName):
	if action in lastDirectionActions:
		Input.action_release(action)
		
		
		
		
