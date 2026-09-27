extends Area2D

@export var levelName: String
@export var levelScene: PackedScene

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var level_name_label: Label = $VBoxContainer/levelNameLabel

var playerEntered = false

func _ready() -> void:
	v_box_container.hide()
	level_name_label.text = levelName

func _input(_event: InputEvent) -> void:
	if not levelScene:
		return
	
	if Input.is_action_just_pressed("ui_accept") and playerEntered:
		_start_level()
		
func _start_level():
	get_tree().change_scene_to_packed(levelScene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if levelScene: 
			v_box_container.show()
		body.canSelectInput = true
		playerEntered = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		v_box_container.hide()
		body.canSelectInput = false
		playerEntered = false
