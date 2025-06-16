extends CharacterBody3D
class_name Weapon

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var label_3d: Label3D = $Label3D

var isSelected = false

func _ready() -> void:
	set_physics_process(false)
	
	label_3d.hide()

func _process(delta: float) -> void:
	var isEquipt = get_parent() is Marker3D
	collision_shape_3d.disabled = isEquipt
	
	label_3d.visible = isSelected
	
	set_physics_process(not isEquipt)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()

func set_selection(boolean: bool):
	isSelected = boolean

func throw(direction):
	reparent(get_tree().current_scene)
	
	velocity = direction * Vector3(6,0,6)
	velocity.y = 6
	
	isSelected = false
