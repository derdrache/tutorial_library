extends AnimatedSprite2D

@export var effectedObjects: Array[Node2D]
@export var duration: float = 2.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtCollisionShape: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var timer: Timer = $Timer

func _on_hurt_box_hurted() -> void:	
	_use()

func _use():
	collision_shape_2d.set_deferred("disabled", true)
	hurtCollisionShape.set_deferred("disabled", true)

	hide()
	
	for object in effectedObjects:
		object.activate()

	timer.start(duration)
	
func _on_timer_timeout() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	hurtCollisionShape.set_deferred("disabled", false)
	
	show()
	
	for object in effectedObjects:
		object.deactivate()
