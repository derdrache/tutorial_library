extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	_set_default_state()
	
	timer.timeout.connect(_on_timer_timeout)
	
func _set_default_state():
	collision_shape_2d.disabled = true
	sprite_2d.modulate.a = 0.2

func interaction():
	collision_shape_2d.disabled = false
	sprite_2d.modulate.a = 1
	
	timer.start()

func _on_timer_timeout():
	_set_default_state()
