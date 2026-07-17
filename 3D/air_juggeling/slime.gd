extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $slime/AnimationPlayer
@onready var damage_indicator: Node3D = $DamageIndicator

var health := 5

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	animation_player.play("idle")

	move_and_slide()

func take_damage(value):
	health -= value
	
	damage_indicator.create_indicator_label(-value)

	# if in the air and get damage => fly up a little bit
	if not is_on_floor():
		velocity.y = 3.0
