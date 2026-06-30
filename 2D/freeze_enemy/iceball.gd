extends Area2D

@export var speed = 200

var direction

func _ready() -> void:
	get_tree().create_timer(3).timeout.connect(queue_free)

func set_direction(newDirection):
	direction = newDirection

func _physics_process(delta: float) -> void:
	if not direction: 
		return
	
	global_position += speed * direction * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		body.get_frozen(2)

		queue_free()
