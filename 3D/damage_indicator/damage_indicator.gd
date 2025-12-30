extends Node3D

@export var font_size := 150
@export var labelRange := 4
@export var animationDuration := 1.5

func create_indicator_label(value):
	var indicatorLabel = _get_custom_label_3d(value)
	
	get_tree().current_scene.add_child(indicatorLabel)
	indicatorLabel.global_position = global_position
	
	_tween_indicator(indicatorLabel)

func _get_custom_label_3d(value):
	var label := Label3D.new()
	label.text = str(value)
	label.font_size = font_size
	label.outline_size = font_size / 2

	label.modulate = _get_indicator_color(value)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	
	return label

func _get_indicator_color(value):
	if  value > 0: return Color.GREEN
	elif value < 0: return Color.RED
	else: return Color.GRAY

func _tween_indicator(label):
	var tween = create_tween()
	var randomTargetPosition = Vector3(
		randf_range(-labelRange,labelRange), 
		randf_range(-labelRange,labelRange), 
		randf_range(-labelRange,labelRange)
		)
	
	tween.tween_property(label, "position", label.position + randomTargetPosition, animationDuration)
	tween.parallel()
	tween.tween_property(label, "modulate:a", 0, animationDuration)
	tween.parallel()
	tween.tween_property(label, "outline_modulate:a", 0, animationDuration)
	
	tween.tween_callback(label.queue_free)
