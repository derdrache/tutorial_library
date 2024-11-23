@tool
extends Control

func _process(delta):
	queue_redraw()
	
func _draw():
	for talentNode in get_tree().get_nodes_in_group("talents"):
		for resource in talentNode.talentResource.unlockTalents:
			var targetNode = _get_node_with_resource(resource)
			
			if targetNode == null: continue
			
			var sourcePosition = (talentNode.global_position) + (talentNode.get_center())
			var targetPosition = (targetNode.global_position) + (targetNode.get_center())
			var color = Color.BLACK if talentNode.talentResource.is_unlocked else Color.GRAY
			
			draw_line(sourcePosition, targetPosition, color, 7.0)

func _get_node_with_resource(resource):
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource == resource:
			return talentNode
