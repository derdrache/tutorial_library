extends RigidBody3D

@export var acceleration := 40.0
@export var steering := 1.5
@export var effectTurnSpeed := 0.1
@export var effectTurnTilt := 0.75

@onready var car: Node3D = $Car
@onready var carMesh: MeshInstance3D = $Car/Car


var speedForce: float
var turnDegree: float

func _ready() -> void:
	add_to_group("player")
	car.top_level = true

func _physics_process(delta: float) -> void:
	car.global_position = global_position - Vector3(0,0.1,0)
	
	speedForce = Input.get_axis("ui_up", "ui_down") * acceleration
	turnDegree = Input.get_axis("ui_right", "ui_left") * deg_to_rad(steering)
	
	_curve_effect(delta)
	
	car.rotate_y(turnDegree)

	apply_force(-car.global_transform.basis.z * speedForce)

func _curve_effect(delta) -> void:
	var turnStrenghtValue = turnDegree * linear_velocity.length() / effectTurnSpeed
	var turnTiltValue = -turnDegree * linear_velocity.length() / effectTurnTilt
	var changeSpeed = 1
	
	if turnDegree == 0: changeSpeed = 3
	
	carMesh.rotation.y = lerp(carMesh.rotation.y, turnStrenghtValue, changeSpeed * delta )
	carMesh.rotation.z = lerp(carMesh.rotation.z, turnTiltValue, changeSpeed * delta )
