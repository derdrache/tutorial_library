extends Control

@onready var nameLabel: Label = %name
@onready var levelLabel: Label = %level
@onready var expLabel: Label = %exp
@onready var strengthLabel: Label = %strength

var dev_drache_resource = preload("res://DevDrache.tres")

var saveAndLoad = SaveAndLoad.new()

func _on_save_button_pressed() -> void:
	dev_drache_resource.level = 7
	dev_drache_resource.current_exp = 4500
	dev_drache_resource.strength = 68
	saveAndLoad.save_resource(saveAndLoad.SAVE_PATH, dev_drache_resource, dev_drache_resource.character_name)


func _on_load_button_pressed() -> void:
	dev_drache_resource.load_stats()	
	
	nameLabel.text = dev_drache_resource.character_name
	levelLabel.text = str(dev_drache_resource.level)
	expLabel.text = str(dev_drache_resource.current_exp)
	strengthLabel.text = str(dev_drache_resource.strength)
