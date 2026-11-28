extends Camera2D

@export var zoomSteps := 0.1
@export var minZoom := Vector2.ONE * 0.5
@export var maxZoom := Vector2.ONE * 2

var targetZoom

func _ready() -> void:
	targetZoom = zoom

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		targetZoom += Vector2.ONE * zoomSteps
	elif Input.is_action_just_pressed("zoom_out"):
		targetZoom -= Vector2.ONE * zoomSteps
	
	targetZoom = targetZoom.clamp(minZoom, maxZoom)

func _physics_process(_delta: float) -> void:
	var smoothZoom = lerp(zoom, targetZoom, 0.1)
	zoom = smoothZoom
