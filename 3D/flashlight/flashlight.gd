extends Node3D

@onready var spot_light_3d: SpotLight3D = $SpotLight3D

func set_light():
	spot_light_3d.visible = not spot_light_3d.visible
