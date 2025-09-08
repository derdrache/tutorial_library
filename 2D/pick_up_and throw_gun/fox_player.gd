extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $RotationNode/AnimatedSprite2D
@onready var rotation_node: Node2D = $RotationNode
@onready var object_marker: Marker2D = $RotationNode/ObjectMarker

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var possiblePickupObjects = []
var currentObject

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaction") and currentObject:
		throw_object()
	elif Input.is_action_just_pressed("interaction") and possiblePickupObjects:
		pickup_object()
		
func throw_object():
	currentObject.reparent(get_tree().current_scene)
	
	var throwDirection = global_position.direction_to(object_marker.global_position)
	currentObject.throw(throwDirection)
	
	currentObject = null
	
func pickup_object():
	currentObject = possiblePickupObjects.pop_front()
	currentObject.global_position = object_marker.global_position
	currentObject.reparent(object_marker)
	
	currentObject.picked_up()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_animation(direction)
	
	move_and_slide()

func _set_animation(direction):
	if direction.x > 0: rotation_node.scale.x = 1
	elif direction.x < 0: rotation_node.scale.x = -1

	if velocity:
		if velocity.y:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("walk")
	else: animated_sprite_2d.play("idle")


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is GameObject:
		possiblePickupObjects.append(body)

func _on_pickup_area_body_exited(body: Node2D) -> void:
	if body is GameObject:
		possiblePickupObjects.erase(body)
