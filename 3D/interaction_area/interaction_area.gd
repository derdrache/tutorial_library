extends Area3D

signal interaction_started()

@export var icon: CompressedTexture2D

@onready var sprite_3d: Sprite3D = $Sprite3D

const INTERACTION_POINT = preload("uid://by2aicaw82xvb")

var canInteract = false

func _ready() -> void:
	sprite_3d.texture = INTERACTION_POINT

func _input(_event: InputEvent) -> void:
	if canInteract and Input.is_action_just_pressed("actionE"):
		interaction_started.emit()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		canInteract = true
		sprite_3d.texture = icon


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		canInteract = false
		sprite_3d.texture = INTERACTION_POINT
