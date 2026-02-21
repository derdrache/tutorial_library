extends CharacterBody2D

@onready var rotation_node: Node2D = $rotationNode
@onready var animated_sprite_2d: AnimatedSprite2D = $rotationNode/AnimatedSprite2D
@onready var arrow_start_marker: Marker2D = $rotationNode/arrowStartMarker

const ARROW = preload("uid://cmjhgeo8j0pb")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var isShooting = false

func _physics_process(_delta: float) -> void:
	if not isShooting:
		_shoot()
		
	_set_animation()
			
	if isShooting:
		return
		
	move_and_slide()

func _shoot():
    isShooting = true
	animated_sprite_2d.play("shoot")

func _set_animation():
	var player = get_tree().get_first_node_in_group("player")
	
	if not player: return
	
	var playerPosition = player.global_position
	var direction = global_position.direction_to(playerPosition)
	
	if direction.x > 0:
		rotation_node.scale.x = 1
	elif direction.x < 0:
		rotation_node.scale.x = -1

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 6:
			_create_arrow()
			
func _create_arrow():
	var arrowNode = ARROW.instantiate()
	
	var player = get_tree().get_first_node_in_group("player")
	arrowNode.direction = global_position.direction_to(player.global_position)
	
	get_tree().current_scene.add_child(arrowNode)
	arrowNode.global_position = arrow_start_marker.global_position


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "shoot":
		isShooting = false
