extends StaticBody2D

@export var interactionObjects: Array[Node2D]

@onready var event_block: AnimatedSprite2D = $EventBlock
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		_interaction()

func _interaction():
	_interaction_animation()
	
	for object in interactionObjects:
		object.call_deferred("interaction")

func _interaction_animation():
	var tween = create_tween()
	tween.tween_property(event_block, "position:y", -5, 0.2)
	tween.tween_property(event_block, "position:y", 0, 0.2)
