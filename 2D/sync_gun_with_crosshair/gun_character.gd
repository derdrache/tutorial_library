extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var crosshair: Sprite2D = $Crosshair
@onready var rotation_node: Node2D = %rotationNode

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta: float) -> void:
	_set_crosshair()
	
	_update_player_and_weapon_direction()

func _set_crosshair():
	crosshair.global_position = get_global_mouse_position().limit_length(200)
	
func _update_player_and_weapon_direction():
	rotation_node.look_at(crosshair.global_position)	
	
	var onLeftSide = get_global_mouse_position().x < global_position.x
	if onLeftSide:
		animated_sprite_2d.flip_h = true
		rotation_node.scale.y = -1
	else:
		animated_sprite_2d.flip_h = false
		rotation_node.scale.y = 1
	
	var onUpperSide = get_global_mouse_position().y < global_position.y
	if onUpperSide:
		rotation_node.z_index = -1
	else:
		rotation_node.z_index = 0
