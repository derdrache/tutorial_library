extends CharacterBody2D

@onready var egg_container: Node2D = %eggContainer
@onready var rotation_node: Node2D = %rotationNode
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var cross_hair: Sprite2D = %CrossHair

const SPEED = 150.0
const EGG = preload("res://egg.tscn")

var JUMP_VELOCITY = -400.0
var isAttacking = false

func _process(delta: float) -> void:
	cross_hair.visible = isAttacking
	
	if isAttacking:
		path_follow_2d.progress += 0.75

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("ui_down") and isAttacking:
			isAttacking = false
			egg_container.get_child(0).show()
		
	if Input.is_action_just_pressed("attack"):
		var hasEggs = egg_container.get_child_count() > 0
		
		if isAttacking:
			isAttacking = false
			_shoot_egg()
		elif hasEggs:
			isAttacking = true
			_prepare_shooting()
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	_set_animation(direction)

	move_and_slide()

func _shoot_egg():
	var selectedEgg = egg_container.get_child(0)
	selectedEgg.show()
	selectedEgg.reparent(get_tree().current_scene)
	selectedEgg.global_position = global_position
	selectedEgg.shoot(cross_hair.global_position)

func _prepare_shooting():
	path_follow_2d.progress_ratio = 0.5
	egg_container.get_child(0).hide()

func _set_animation(direction):
	if direction < 0: rotation_node.scale.x = 1
	elif direction > 0: rotation_node.scale.x = -1
	
	if isAttacking:
		animated_sprite_2d.play("shoot_idle")
	elif is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
