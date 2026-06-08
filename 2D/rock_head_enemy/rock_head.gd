extends CharacterBody2D

@export var waitTime = 2.0

enum States {WAITING, GO_DOWN, GO_UP}

const SPEED = 300.0

var startPosition: Vector2
var currentState: States

func _ready() -> void:
	startPosition = global_position

	_waiting()

func _waiting():
	currentState = States.WAITING
	
	await get_tree().create_timer(waitTime).timeout
	
	currentState = States.GO_DOWN

func _physics_process(_delta: float) -> void:
	if currentState == States.GO_DOWN:
		velocity.y = SPEED
	elif currentState == States.GO_UP:
		velocity.y = -SPEED / 3
		
		if global_position.distance_to(startPosition) < 10:
			global_position = startPosition
			_waiting()
	else:
		velocity.y = 0

	move_and_slide()

	if get_last_slide_collision():
		currentState = States.GO_UP

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
