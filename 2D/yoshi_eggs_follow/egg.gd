extends CharacterBody2D

var speed = 0.0
var onTween = false

func _ready() -> void:
	add_to_group("eggs")

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	var eggs = get_tree().get_nodes_in_group("eggs")
	
	var playerFloorPosition = player.global_position + Vector2(0, 20)
	var lastEggOnFloor = (eggs[-1].global_position.y < playerFloorPosition.y + 10 
		and eggs[-1].global_position.y  > playerFloorPosition.y - 10)

	if not lastEggOnFloor or player.velocity or speed > 0:
		var distanceBetween = lerp(10, 30, abs(player.velocity.x) / player.MAX_SPEED)
	
		var targetPosition = _get_target_position(eggs, player)
		var direction = (targetPosition - global_position).normalized()
		
		if not lastEggOnFloor:
			distanceBetween = 0
			
		if speed < player.speed:
			speed = player.speed

		if player.velocity == Vector2.ZERO and lastEggOnFloor:
			speed -= 5
			
		if not player.is_on_floor():
			speed = 150
			distanceBetween = 15
			
		if global_position.distance_to(targetPosition) > distanceBetween:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			
		_egg_aimation()
		
		move_and_slide()

func _get_target_position(eggs, player):
	var eggNumber = get_index()
	
	if eggNumber == 0:
		return player.egg_marker.global_position
	else:
		return eggs[eggNumber -1].global_position

func _egg_aimation():
	if onTween: return

	onTween = true
	
	var startPosition = $Sprite2D.position
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0,-1), 0.2)
	tween.tween_property($Sprite2D, "position", startPosition, 0.1)
	await tween.finished
	
	onTween = false
	
	
