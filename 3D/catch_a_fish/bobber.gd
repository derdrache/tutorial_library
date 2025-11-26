extends CharacterBody3D

signal landed()
signal fish_hooked(fish)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fish_position_marker: Marker3D = $fishPositionMarker

func _ready() -> void:
	add_to_group("bobber")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and velocity.y <= 0:
		velocity = Vector3.ZERO

	move_and_slide()

	if is_on_floor():
		global_position.y -= 0.05
		var ground = get_last_slide_collision()
		landed.emit(ground.get_collider())
		set_physics_process(false)

func shake():
	animation_player.play("shake")
	await animation_player.animation_finished

func bite(fish):
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", -0.25, 0.2)
	fish_hooked.emit(fish)
