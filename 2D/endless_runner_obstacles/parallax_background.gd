extends ParallaxBackground

@onready var sky: ParallaxLayer = $ParallaxLayer
@onready var wood1: ParallaxLayer = $ParallaxLayer2
@onready var wood2: ParallaxLayer = $ParallaxLayer3

@export var skySpeed = 0.1
@export var woodSpeed = 0.2

func _process(delta: float) -> void:
	sky.motion_offset -= Vector2(skySpeed,0)
	wood1.motion_offset -= Vector2(woodSpeed,0)
	wood2.motion_offset -= Vector2(woodSpeed,0)
