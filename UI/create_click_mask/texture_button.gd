extends TextureButton

func _ready() -> void:
	var bitmap = BitMap.new()
	var image = texture_normal.get_image()

	bitmap.create_from_image_alpha(image)

	texture_click_mask = bitmap
