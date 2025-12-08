extends StaticBody3D

@onready var animation_player: AnimationPlayer = $spring/AnimationPlayer


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animation_player.play("start")
		body.velocity.y = 12
