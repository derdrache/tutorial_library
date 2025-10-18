extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: HitBox = $HitBox

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		_attack()
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _attack():
	set_physics_process(false)
	
	animated_sprite_2d.play("attack")
	
	await animated_sprite_2d.animation_finished
	
	set_physics_process(true)

func _set_animation():
	if velocity:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")


func _on_animated_sprite_2d_frame_changed() -> void:
	if not animated_sprite_2d: return
	
	var attackAnimation = animated_sprite_2d.animation == "attack"
	var frame = animated_sprite_2d.frame
	
	if attackAnimation:
		if frame == 3:
			hit_box.set_active(true)
		elif frame == 5:
			hit_box.set_active(false)
