extends StaticBody3D

@onready var sit_marker: Marker3D = $sitMarker
@onready var label_3d: Label3D = $Label3D

var canInteract = false
var isSitting = false

func _ready() -> void:
	label_3d.hide()

func _input(event: InputEvent) -> void:
	if not canInteract: return
	
	if Input.is_action_just_pressed("interaction") and not isSitting:
		_sit()
	elif Input.is_action_just_pressed("interaction") and isSitting:
		_release()

func _sit():
	isSitting = true
	
	var player = get_tree().get_first_node_in_group("player")
	player = get_tree().get_first_node_in_group("player")
	player.global_position = sit_marker.global_position
	player.sit()
	player.look_at(player.global_position + global_basis.x)
	
	label_3d.hide()
	
func _release():
	isSitting = false
	
	var player = get_tree().get_first_node_in_group("player")
	player.set_physics_process(true)
	
	player.global_position = global_position - global_basis.x
	
	label_3d.show()
	
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_set_interaction(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_set_interaction(false)

func _set_interaction(boolean: bool):
	label_3d.visible = boolean
	canInteract = boolean
