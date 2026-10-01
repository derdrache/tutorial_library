extends CharacterBody3D

@onready var enemy_vision: Area3D = $EnemyVision
@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	sprite_3d.hide()
	enemy_vision.player_detacted.connect(_on_player_detected)
	
func _on_player_detected():
	sprite_3d.show()
