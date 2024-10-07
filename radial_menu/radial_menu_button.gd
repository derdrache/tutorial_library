extends Button

@onready var button_container: Control = %ButtonContainer

@export var radius = 150
@export var animationSpeed = 0.25

var active = false
var centerPosition

func _ready() -> void:
	centerPosition = global_position + get_rect().size / 2 - button_container.get_rect().size / 2
	button_container.hide()
	
	for button in button_container.get_children():
		button.global_position = centerPosition
		button.pressed.connect(_select_option.bind(button.name))

func _show_menu():
	var spacing = TAU / button_container.get_child_count()
	
	for button in button_container.get_children():
		var angle = spacing * button.get_index() - PI
		var targetDirection = Vector2(radius, 0).rotated(angle)
		var targetPosition = button.global_position - button.get_rect().size / 2 + targetDirection
		
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", targetPosition, animationSpeed)
		tween.parallel()
		tween.tween_property(button, "scale", Vector2.ONE, animationSpeed)
		
	await get_tree().create_timer(animationSpeed).timeout
	
	disabled = false
	active = true
	
	button_container.show()

func _hide_menu():
	for button in button_container.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", centerPosition, animationSpeed)
		tween.parallel()
		tween.tween_property(button, "scale", Vector2.ONE / 2, animationSpeed)
		
	await get_tree().create_timer(animationSpeed).timeout
	
	disabled = false
	active = false
	
	button_container.hide()

func _select_option(buttonName):
	_hide_menu()
	
	#do whatever you want

func _on_pressed() -> void:
	disabled = true
	
	if active: _hide_menu()
	else: _show_menu()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
