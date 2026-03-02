extends StaticBody3D

@export var item = ""

var inRange

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaction") and inRange:
		_pick_up()
		
func _pick_up():
	GameManager.gather_item(item, 1)
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = false
