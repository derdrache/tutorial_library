extends CharacterBody2D

@onready var speed_car = $SpeedCar
@onready var car_collision___rotation_node = $"carCollision"
@onready var enter_hint_label = $Label

const SPEED = 200.0

var activePlayer = false

func _ready():
	enter_hint_label.visible = false

func _input(event):
	if event.is_action_pressed("interaction") && event.is_pressed() && enter_hint_label.visible:
		_control_car()
	elif activePlayer && event.is_action_pressed("interaction") && event.is_pressed():
		_leave_car()
		
func _control_car():
	var player = get_tree().get_first_node_in_group("player")
	
	activePlayer = true
	player.queue_free()

func _leave_car():
	var player = preload("res://tutorial_collection/player/normal_player.tscn").instantiate()
	
	activePlayer = false
	get_tree().current_scene.add_child(player)
	player.global_position = global_position

func _physics_process(delta):
	if not activePlayer: return
	
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
	if velocity.y < 0 && velocity.x < 0:
		speed_car.play("up_left")
		car_collision___rotation_node.rotation_degrees = -45
	elif velocity.y < 0 && velocity.x > 0:
		speed_car.play("up_right")
		car_collision___rotation_node.rotation_degrees = 45
	elif velocity.y > 0 && velocity.x < 0:
		speed_car.play("down_left")
		car_collision___rotation_node.rotation_degrees = -135
	elif velocity.y > 0 && velocity.x > 0:
		speed_car.play("down_right")
		car_collision___rotation_node.rotation_degrees = 135
	elif velocity.x < 0:
		speed_car.play("left")
		car_collision___rotation_node.rotation_degrees = -90
	elif velocity.x > 0:
		speed_car.play("right")
		car_collision___rotation_node.rotation_degrees = 90
	elif velocity.y < 0 :
		speed_car.play("up")
		car_collision___rotation_node.rotation_degrees = 0
	elif velocity.y > 0:
		speed_car.play("down")
		car_collision___rotation_node.rotation_degrees = 180

func _on_area_2d_body_entered(body):
	if body == get_tree().get_first_node_in_group("player"):
		enter_hint_label.show()


func _on_area_2d_body_exited(body):
	if body == get_tree().get_first_node_in_group("player"):
		enter_hint_label.hide()
