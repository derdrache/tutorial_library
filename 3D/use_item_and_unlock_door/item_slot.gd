extends PanelContainer

@export var itemResource: Resource:
	set(value):
		itemResource = value
		
		_refresh()
		
func _refresh():
	if itemResource:
		$TextureRect.texture = itemResource.icon
	else:
		$TextureRect.texture = null
