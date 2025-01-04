extends Node2D

func _on_command_menu_command_selected(command: Resource) -> void:
	$CanvasLayer/CommandLabel.text = "use " + command.name
