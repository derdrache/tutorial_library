extends StaticBody3D

@export var quests: Array[Quest]

@onready var label_3d: Label3D = $Label3D

var inRange = false

func _ready() -> void:
	label_3d.hide()
	
func _input(_event: InputEvent) -> void:
	if not inRange: return
	
	if Input.is_action_just_pressed("interaction") and not quests.is_empty():
		_get_quest()

func _get_quest():
	var randomPick = quests.pick_random()
	GameManager.add_quest(randomPick)
	quests.erase(randomPick)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_in_range(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_in_range(false)

func _in_range(boolean: bool):
	inRange = boolean
	label_3d.visible = not quests.is_empty()
