extends PanelContainer

@export var quest: Quest

@onready var title_label: Label = %titleLabel
@onready var brief_description_label: Label = %briefDescriptionLabel

func _ready() -> void:
	_refresh()
	
func _refresh():
	title_label.text = quest.name
	brief_description_label.text = quest.brief_description
	
