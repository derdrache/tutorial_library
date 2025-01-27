extends CharacterBody2D

@export var characterResource: Resource

@onready var canvas_layer: CanvasLayer = $CanvasLayer

const TALENT_TREE = preload("res://talent_tree.tscn")

var isTalentTreeOpen = false

func _ready() -> void:
	print(characterResource.get_character_stats())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") and not isTalentTreeOpen: 
		_open_talent_tree()
	elif event.is_action_pressed("interaction") and isTalentTreeOpen: 
		_close_talent_tree()
	
func _open_talent_tree():
	isTalentTreeOpen = true
	var talentTreeNode = TALENT_TREE.instantiate()
	talentTreeNode.activeTalents = characterResource.talents
	canvas_layer.add_child(talentTreeNode)
	
func _close_talent_tree():
	isTalentTreeOpen = false
	canvas_layer.get_children()[0].queue_free()
