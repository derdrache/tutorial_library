extends CharacterBody2D

@onready var speed_car = $SpeedCar
@onready var car_collision = $carCollision
@onready var lights = $carCollision/lights


const SPEED = 200.0

func _ready():
	lights.visible = false

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		lights.visible = not lights.visible
	
	var direction = Vector2.ZERO
	direction.x  = Input.get_axis("ui_left", "ui_right")
	direction.y =  Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity: lights.position = Vector2.ZERO
	
	if velocity.y < 0 && velocity.x < 0:
		speed_car.play("up_left")
		car_collision.rotation_degrees = -45
	elif velocity.y < 0 && velocity.x > 0:
		speed_car.play("up_right")
		car_collision.rotation_degrees = 45
	elif velocity.y > 0 && velocity.x < 0:
		speed_car.play("down_left")
		car_collision.rotation_degrees = -135
	elif velocity.y > 0 && velocity.x > 0:
		speed_car.play("down_right")
		car_collision.rotation_degrees = 135
	elif velocity.x < 0:
		speed_car.play("left")
		car_collision.rotation_degrees = -90
		lights.position.y -= 10
	elif velocity.x > 0:
		speed_car.play("right")
		car_collision.rotation_degrees = 90
		lights.position.y -= 10
	elif velocity.y < 0 :
		speed_car.play("up")
		car_collision.rotation_degrees = 0
	elif velocity.y > 0:
		speed_car.play("down")
		car_collision.rotation_degrees = 180

