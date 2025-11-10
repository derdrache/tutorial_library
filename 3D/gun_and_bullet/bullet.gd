extends Area3D

@export var direction: Vector3

var speed = 50

func _ready() -> void:
	_self_destruction()
	
func _self_destruction():
	get_tree().create_timer(2).timeout.connect(queue_free)

func _physics_process(delta):
	if not direction: return
	
	global_position += direction * speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
		queue_free()

func _on_body_entered(_body: Node3D) -> void:
	queue_free()
