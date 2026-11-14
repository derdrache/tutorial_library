@tool
extends Sprite2D

@export var fogSize := Vector2i(3000, 1500):
	set(value):
		fogSize = value
@export var lightSize := Vector2i(400, 400)

const LIGHT = preload("uid://2fb5i5hkl1kq")

var lightImage: Image

func _ready() -> void:
	generate_fog()
	
	_set_light_data()
	
	z_index = 99

func generate_fog() -> void:
	offset = fogSize / 2.0
	
	var fogImage = Image.create(fogSize.x, fogSize.y, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color.BLACK)
	
	var fogTexture = ImageTexture.create_from_image(fogImage)
	texture = fogTexture

func _set_light_data():
	lightImage = LIGHT.get_image()
	lightImage.convert(Image.FORMAT_RGBA8)
	lightImage.resize(lightSize.x, lightSize.y)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var player = get_tree().get_first_node_in_group("player")
	update_fog(player.global_position - global_position )

func update_fog(pos):
	var fogTexture = texture
	var fogImage: Image = texture.get_image().duplicate()

	var lightRect = Rect2(Vector2.ZERO, lightImage.get_size())
	var lightOffSet = Vector2(lightSize.x / 2.0, lightSize.y / 2.0)
	fogImage.blend_rect(lightImage, lightRect, pos - lightOffSet)
	fogTexture.update(fogImage)
