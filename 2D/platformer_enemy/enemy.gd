extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_timer: Timer = $StateTimer
@onready var look_timer: Timer = $LookTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

enum States{WALKING, LOOKING}

const SPEED = 30.0

var currentState: States
var direction = 1

func _ready() -> void:
	currentState = States.LOOKING
	state_timer.wait_time = randi_range(2,3)
	state_timer.start()
	start_looking()
	
func start_looking():
	velocity.x = 0
	animated_sprite_2d.stop()
	
	look_timer.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not ray_cast_2d.is_colliding() and currentState == States.WALKING:
		change_look_direction()
		
	match currentState:
		States.WALKING: do_walk(delta)

	move_and_slide()

func do_walk(delta):
	velocity.x = SPEED * direction
	
	animated_sprite_2d.play("idle")


func _on_state_timer_timeout() -> void:
	match currentState:
		States.WALKING: 
			currentState = States.LOOKING
			start_looking()
		States.LOOKING: 
			currentState = States.WALKING	
			look_timer.stop()
	
	state_timer.wait_time = randi_range(2,3)
	state_timer.start()


func _on_look_timer_timeout() -> void:
	change_look_direction()

func change_look_direction():
	direction *= -1
	animated_sprite_2d.scale.x = direction
	ray_cast_2d.position.x = direction * 3
