extends CharacterBody3D

signal parry_window_opened()

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer
@onready var hit_box: Area3D = $"Barbarian/Rig/Skeleton3D/2H_Axe/HitBox"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _init() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if animation_player.current_animation == "Use_Item": 
		hit_box.monitoring = false
		return

	animation_player.play("2H_Melee_Attack_Slice")

	move_and_slide()
	
func parry_window():
	parry_window_opened.emit()

func got_parried():
	animation_player.play("Use_Item")
