extends StaticBody2D

@onready var turn_based_agent: TurnBasedAgent = $TurnBasedAgent

func _ready() -> void:
	turn_based_agent.target_selected.connect(_on_target_selected)
	
func _on_target_selected(target: TurnBasedAgent, command: Resource):
	# here you put every interaction between the character and his targets
	# like:
	# animation
	# damage/heal/buffs
	# interaction with Hp Bars
	# and more
	
	await _animation_example(target)

	turn_based_agent.command_done()

func _animation_example(target):
	var startPosition = global_position
	var targetPosition = target.get_global_position()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", targetPosition, 0.5)
	tween.tween_property(self, "global_position", startPosition, 0.5)
	
	await tween.finished
	
	
