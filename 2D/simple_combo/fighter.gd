extends CharacterBody2D

@onready var playerAnimation = $AnimatedSprite2D
@onready var effectAnimation = $effectPlayer
@onready var comboResetTimer = $comboResetTimer
@onready var energyAura = $energyAura

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum attack_states {RESET, LEFT_HIT, RIGHT_HIT, KICK, COLLECT_ENERGY, ENERGY_BALL}
var lastAttack = attack_states.RESET
var doAttack = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	attack_and_animation()

	move_and_slide()
	
func attack_and_animation():
	if doAttack: return
	
	doAttack = true
	
	if Input.is_action_just_pressed("move_up") && energyAura.visible:
		lastAttack = attack_states.ENERGY_BALL
		playerAnimation.play("energy_ball")
		await  get_tree().create_timer(0.7).timeout
		effectAnimation.play("energyBall")
	elif Input.is_action_just_pressed("move_up"):
		lastAttack = attack_states.COLLECT_ENERGY
		playerAnimation.play("collect_energy")
		
	elif Input.is_action_just_pressed("attack") && lastAttack == attack_states.RIGHT_HIT:
		lastAttack = attack_states.KICK
		playerAnimation.play("kick")
	elif Input.is_action_just_pressed("attack") && lastAttack == attack_states.LEFT_HIT:
		lastAttack = attack_states.RIGHT_HIT
		playerAnimation.play("hit_right")
	elif Input.is_action_just_pressed("attack"):
		lastAttack = attack_states.LEFT_HIT
		playerAnimation.play("hit_left")
	
	elif velocity.x > 0:
		playerAnimation.play("move_forward")
	elif velocity.x < 0:
		playerAnimation.play("move_back")
	else:
		doAttack = false
		playerAnimation.play("idle")
		
func _on_animated_sprite_2d_animation_finished():
	doAttack = false
	comboResetTimer.start()
	
	if playerAnimation.animation == "collect_energy":
		energyAura.visible = true
	elif playerAnimation.animation == "energy_ball":
		energyAura.visible = false


func _on_combo_reset_timer_timeout():
	lastAttack = attack_states.RESET
