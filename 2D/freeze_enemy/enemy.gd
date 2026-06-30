
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var freeze_sprite: Sprite2D = $FreezeSprite

const SPEED = 50.0

var health := 10
var isFrozen = false

func _ready() -> void:
	freeze_sprite.hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var player = get_tree().get_first_node_in_group("player")
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0
	
	velocity = direction * SPEED
	
	animated_sprite_2d.flip_h = global_position.direction_to(player.global_position).x < 0
	
	animated_sprite_2d.play("walk")
	
	move_and_slide()

func take_damage(value):
	health -= value
	
	if health <= 0:
		queue_free()

func get_frozen(timeValue):
	if isFrozen: return
	
	isFrozen = true
	_set_freeze_animation(true)
	
	set_physics_process(false)
	await get_tree().create_timer(timeValue).timeout
	set_physics_process(true)

	isFrozen = false
	_set_freeze_animation(false)

func _set_freeze_animation(boolean: bool):
	freeze_sprite.visible = boolean
	animated_sprite_2d.pause()
