extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

const SPEED = 150.0

var JUMP_VELOCITY = -400.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	_set_animation(direction)

	move_and_slide()
		
func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = false
	elif direction > 0: animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")

func get_hit():
	get_tree().paused = true
	set_physics_process(false)
	
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	
	get_tree().paused = false

	get_tree().reload_current_scene()
	set_physics_process(true)
