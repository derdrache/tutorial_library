extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var dashDurationTimer = $DashDurationTimer
@onready var dashEffectTimer = $DashEffectTimer

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doDash = false
var dashDirection : int


func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	var dashSpeedMultiplicator = 3
	
	if not is_on_floor(): velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack"):
		dashDirection = -1 if animatedSprite.flip_h else 1
		doDash = true
		dashDurationTimer.start()
		dashEffectTimer.start()
		
	if doDash:
		velocity.x = dashDirection * SPEED * dashSpeedMultiplicator
		velocity.y = 0
	elif direction:velocity.x = direction * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_set_animation()
	
	move_and_slide()
	
func _set_animation():
	if !is_on_floor(): animatedSprite.play("jump")
	elif velocity != Vector2.ZERO: animatedSprite.play("run")
	else: animatedSprite.play("idle")

	if velocity.x > 0: animatedSprite.flip_h = false
	elif velocity.x < 0: animatedSprite.flip_h = true
	
func create_dash_effect():
	var playerCopyNode = $AnimatedSprite2D.duplicate()
	get_parent().add_child(playerCopyNode)
	playerCopyNode.global_position = global_position
	
	var animationTime = dashDurationTimer.wait_time / 3
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.modulate.a = 0.4
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.modulate.a = 0.2
	await get_tree().create_timer(animationTime).timeout
	playerCopyNode.queue_free()


func _on_dash_duration_timer_timeout():
	doDash = false
	dashEffectTimer.stop()

func _on_dash_effect_timer_timeout():
	create_dash_effect()
