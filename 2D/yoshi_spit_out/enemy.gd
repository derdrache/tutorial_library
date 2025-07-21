extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const ROLL_SPEED = 170
const ROLL_ROTATION_SPEED = 30

var catcher: CharacterBody2D
var offSet = Vector2(0,8)
var rollDirection = false

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if catcher:
		var direction = global_position.direction_to(catcher.global_position)
		global_position = catcher.global_position + (direction.x * catcher.ray_cast_2d.target_position) + offSet
		
		if global_position.distance_to(catcher.global_position) < 18:
			catcher.eat()
			disable(true)
			catcher = null
	else:
		if rollDirection:
			rotation_degrees += rollDirection.x * ROLL_ROTATION_SPEED
			velocity.x = rollDirection.x * ROLL_SPEED
		
		move_and_slide()

func catch(player: CharacterBody2D):
	catcher = player

func disable(boolean):
	visible = not boolean
	collision_shape_2d.disabled = boolean
	set_physics_process(not boolean)

func spit_out(direction):
	rollDirection = direction
