extends Node

signal group_added(group, node)
signal group_exited(group, node)

func add_node_to_group(node: Node, group: String) -> void:
	node.add_to_group(group)
	group_added.emit(group, node)

func remove_node_from_group(node: Node, group: String) -> void:
	node.remove_from_group(group)
	group_exited.emit(group, node)
