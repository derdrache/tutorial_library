extends Area3D

@export var damage := 10

func _ready() -> void:
	monitoring = false
	
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area3D):
	if area.has_method("take_damage"):
		area.take_damage(damage)
		
