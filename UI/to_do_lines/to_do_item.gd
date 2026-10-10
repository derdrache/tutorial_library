extends HBoxContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	rich_text_label.bbcode_enabled = true

func _on_check_box_toggled(toggled_on: bool) -> void:
	_change_text(toggled_on)
	
func _change_text(toddled_on: bool):
	if toddled_on:
		rich_text_label.text = "[s color=black]" + rich_text_label.text + "[/s]"
	else:
		var newText = rich_text_label.text.replace("[s color=black]", "")
		newText = newText.replace("[/s]", "")
		
		rich_text_label.text = newText
