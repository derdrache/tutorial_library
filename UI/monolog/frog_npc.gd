extends CharacterBody2D

@onready var dialog: Node = %Dialog
@onready var dialog_indicator: TextureRect = %DialogIndicator

func _ready() -> void:
	dialog_indicator.hide()

func _on_talk_range_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		dialog_indicator.show()
		dialog.inTalkRange = true


func _on_talk_range_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		dialog_indicator.hide()
		dialog.inTalkRange = false
