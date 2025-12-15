extends StaticBody3D
class_name Rail

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

var body: Node3D

func _physics_process(delta: float) -> void:
	if not body: return
	
	path_follow_3d.progress_ratio += 0.5 * delta
	body.model.look_at(path_follow_3d.global_position, Vector3.UP, true)
	body.global_position = path_follow_3d.global_position

func start_slide():
	body = get_tree().get_first_node_in_group("player")
	
	var firstPoint = global_position + path_3d.curve.get_baked_points()[0]
	var localBodyPosition = to_local(body.global_position)
	var closestPoint =  global_position + path_3d.curve.get_closest_point(localBodyPosition)
	
	path_follow_3d.progress = firstPoint.distance_to(closestPoint)
	
	body.global_position = closestPoint

func stop_slide():
	body = null
