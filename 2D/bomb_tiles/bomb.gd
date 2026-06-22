extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var explosionRange = Vector2i(32,32)

func _ready() -> void:
	# showcase only
	get_tree().create_timer(1).timeout.connect(use)

func use():
	animated_sprite_2d.play("explosion")
	
	await animated_sprite_2d.animation_finished
	
	queue_free()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "explosion":
		if animated_sprite_2d.frame == 14:
			_destroy_tiles()

func _destroy_tiles():
	var startPoint = global_position - Vector2(explosionRange)
	var tileMaps = get_tree().get_nodes_in_group("destroyable_tiles")
	
	for tileMap:TileMapLayer in tileMaps:	
		for x in explosionRange.x * 2:
			for y in explosionRange.y * 2:
				var point = startPoint + Vector2(x,y)
				var tileMapPoint = tileMap.local_to_map(point)
				
				tileMap.set_cell(tileMapPoint)
