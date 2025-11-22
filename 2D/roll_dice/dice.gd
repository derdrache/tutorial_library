extends StaticBody2D

signal roll_done(index:int)

@onready var faces: Node2D = $faces
@onready var label: Label = $Label

var isRolling = false
var currentIndex = 0

func _ready() -> void:
	_set_start_face()
	
	label.text = ""
	
func _set_start_face():
	for face in faces.get_children():
		face.hide()
		
	faces.get_child(0).show()

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("leftClick") and not isRolling:
		_roll_dice()

func _roll_dice():
	var duration := 1.0
	
	isRolling = true
	label.text = ""
	
	while duration > 0:
		var newIndex = faces.get_children().pick_random().get_index()
		faces.get_child(currentIndex).hide()
		faces.get_child(newIndex).show()
		
		await get_tree().create_timer(0.1).timeout
		
		currentIndex = newIndex
		duration -= 0.1
	
	isRolling = false
	
	roll_done.emit(currentIndex + 1)
	

func _on_roll_done(index: int) -> void:
		label.text = str(index)
		
		
		
		
