extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	deactivate()

func activate():
	show()
	
	collision_shape_2d.set_deferred("disabled", false)

func deactivate():
	hide()
	
	collision_shape_2d.set_deferred("disabled", true)
