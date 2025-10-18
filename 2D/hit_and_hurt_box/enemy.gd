extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_hurt_box_died() -> void:
	animated_sprite_2d.play("die")

func _on_hurt_box_hurted() -> void:
	animated_sprite_2d.play("hurt")
