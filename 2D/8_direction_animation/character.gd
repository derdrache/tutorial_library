extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

var lastDirections = [Vector2.ZERO]

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		_set_last_direction(direction)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	set_animation(direction)

	move_and_slide()

func _set_last_direction(direction):
	lastDirections.push_back(direction)
	if lastDirections.size() > 4:
		lastDirections.pop_front()

func set_animation(direction):
	if direction:
		_set_walk_animation(direction)
	else:
		_set_idle_animation(direction)

func _set_walk_animation(direction):
	match direction:
		Vector2(1,0): animated_sprite_2d.play("walk_r")
		Vector2(-1,0): animated_sprite_2d.play("walk_l")
		Vector2(0,1): animated_sprite_2d.play("walk_d")
		Vector2(0,-1): animated_sprite_2d.play("walk_t")
		Vector2(1,1): animated_sprite_2d.play("walk_dr")
		Vector2(-1,-1): animated_sprite_2d.play("walk_tl")
		Vector2(1,-1): animated_sprite_2d.play("walk_tr")
		Vector2(-1,1): animated_sprite_2d.play("walk_dl")
		
func _set_idle_animation(direction):
	match lastDirections[0]:
		Vector2(1,0): animated_sprite_2d.play("idle_r")
		Vector2(-1,0): animated_sprite_2d.play("idle_l")
		Vector2(0,1): animated_sprite_2d.play("idle_d")
		Vector2(0,-1): animated_sprite_2d.play("idle_t")
		Vector2(1,1): animated_sprite_2d.play("idle_dr")
		Vector2(-1,-1): animated_sprite_2d.play("idle_tl")
		Vector2(1,-1): animated_sprite_2d.play("idle_tr")
		Vector2(-1,1): animated_sprite_2d.play("idle_dl")
