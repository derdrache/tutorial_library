extends HBoxContainer

signal refreshed(texture: CompressedTexture2D)

@export var textureOptions: Array[CompressedTexture2D]

@onready var label: Label = $Label

var currentSelection = 0

func _ready() -> void:
	await get_tree().process_frame
	
	_refresh_option()

func _refresh_option():
	var texture = textureOptions[currentSelection]
	var textureName = texture.get_path().get_file().split(".")[0]
	label.text = textureName
	
	refreshed.emit(texture)
	
func _on_back_button_pressed() -> void:
	currentSelection -= 1
	
	if currentSelection < 0:
		currentSelection = textureOptions.size() -1
		
	_refresh_option()


func _on_forward_button_pressed() -> void:
	currentSelection += 1
	
	if currentSelection > textureOptions.size() -1:
		currentSelection = 0
	
	_refresh_option()
	
	
	
	
