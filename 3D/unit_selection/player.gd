extends CharacterBody3D

@onready var selection_mesh: MeshInstance3D = $SelectionMesh

func _ready() -> void:
	add_to_group("player")
	
	#selection_mesh.hide()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func set_selection(boolean: bool):
	selection_mesh.visible = boolean
