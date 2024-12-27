extends CharacterBody3D

@onready var marker_3d = $Marker3D

const SPEED = 5.0
const FIREBALL = preload("res://tutorial_collection/dragon_fireball/Fireball.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group("player")

func _physics_process(delta):
	
	if Input.is_action_just_pressed("attack"):
		_shoot_fireball()

	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	$dragon/AnimationPlayer.play("Flying")

	move_and_slide()

func _shoot_fireball():
	var fireball_node = FIREBALL.instantiate()
	get_parent().add_child(fireball_node)
	fireball_node.global_position = marker_3d.global_position
