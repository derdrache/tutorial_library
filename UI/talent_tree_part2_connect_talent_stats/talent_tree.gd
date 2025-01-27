@tool
extends Control

@export var activeTalents = []

func _ready() -> void:
	_set_unlocked_talents()

func _set_unlocked_talents():
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource in activeTalents:
			talentNode.unlock_talent()

func _process(delta):
	queue_redraw()
	
func _draw():
	for talentNode in get_tree().get_nodes_in_group("talents"):
		for resource in talentNode.talentResource.unlockTalents:
			var targetNode = _get_node_with_resource(resource)
			
			if targetNode == null: continue
			
			var sourcePosition = (talentNode.global_position) + (talentNode.get_center())
			var targetPosition = (targetNode.global_position) + (targetNode.get_center())
			var color = Color.BLACK if talentNode.talentResource in activeTalents else Color.GRAY
			
			draw_line(sourcePosition, targetPosition, color, 7.0)

func _get_node_with_resource(resource):
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource == resource:
			return talentNode
