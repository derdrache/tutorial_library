extends Node3D

signal finished(results: Array[String])

@onready var roll: Node3D = %Roll
@onready var roll_1: Node3D = %Roll1
@onready var roll_2: Node3D = %Roll2
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var ative = false
var startDegree = -14
var degreeBetween = 360.0 / 5.0
var degreeToSymbol = {
	-14: "Melone",
	58: "Orange",
	130: "Seven",
	202: "Shamrock",
	274: "Spade"
}
var rollDict = {}

func _ready() -> void:
	rollDict = {
		0: {"node": roll, "tween": null},
		1: {"node": roll_1, "tween": null},
		2: {"node": roll_2, "tween": null}
	}

func get_result():
	var results = []
	
	for i in rollDict.size():
		var xDegree = rollDict[i].node.rotation_degrees.x
		xDegree = int(round(xDegree))
		results.append(degreeToSymbol[xDegree])

	return results

func _on_handle_body_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and not ative:
		ative = true
		
		animation_player.play("start")
		
		await animation_player.animation_finished
		
		await _start()
		
		_finish()

func _start():
	for i in rollDict.size():
		var randomSpeed = randf_range(0.9, 1.1)
		rollDict[i].tween = create_tween().set_loops()
		rollDict[i].tween.tween_property(
			rollDict[i].node, "rotation_degrees:x", 360 + startDegree, randomSpeed).from(startDegree)
		await get_tree().create_timer(0.5).timeout

func _finish():
	var randomFloat = randf_range(2,4)
	await get_tree().create_timer(randomFloat).timeout

	for i in rollDict.size():
		rollDict[i].tween.stop()
		
		var endXDegree = snappedf(rollDict[i].node.rotation_degrees.x, degreeBetween)
		endXDegree += startDegree + degreeBetween
		
		var tween = create_tween()
		tween.tween_property(rollDict[i].node, "rotation_degrees:x", endXDegree, 0.8)

		await tween.finished

		if rollDict[i].node.rotation_degrees.x >= 360 + startDegree:
			rollDict[i].node.rotation_degrees.x -= 360

	ative = false
	

	
	
	
	
