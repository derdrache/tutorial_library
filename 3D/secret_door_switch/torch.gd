extends Node3D

@export var interactionObject: Node3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var canUse = false
var used = false

func _on_static_body_3d_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and canUse and not used:
		_use()
		
func _use():
	
	used = true
	animation_player.play("use")
	
	await animation_player.animation_finished
	
	interactionObject.interaction()

func _process(_delta: float) -> void:
	canUse = ray_cast_3d.is_colliding()
