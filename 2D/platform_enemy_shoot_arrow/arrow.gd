extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var direction: Vector2
var speed = 300.0

func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if direction:
		global_position += direction * speed * delta
		look_at(global_position + direction)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_damage(1)
		
	queue_free()
