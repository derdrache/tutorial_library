extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var ray_cast_3d: RayCast3D = $model/RayCast3D
@onready var item_bar: Control = $CanvasLayer/ItemBar
@onready var rightHand: BoneAttachment3D = $"model/Rig/Skeleton3D/1H_Sword"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var lastRaycastCollision
var onAction = false

func _ready() -> void:
	item_bar.item_changed.connect(_on_item_bar_item_changed)

func _on_item_bar_item_changed(item:ITEM_BAR_ITEM):
	var toolNumber = -1
	
	if item:
		match item.itemType:
			ITEM_BAR_ITEM.ITEM_TYPES.HOE:
				toolNumber = 1
			ITEM_BAR_ITEM.ITEM_TYPES.WATERING_CAN:
				toolNumber = 2
			
	for tool in rightHand.get_children():
		tool.visible = tool.get_index() == toolNumber

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("actionQ") and lastRaycastCollision.has_method("tool_interaction"):
		var currentItem = item_bar.get_current_item()
		var isUsingTool = _check_using_tool(currentItem)

		if not onAction and isUsingTool:
			_use_tool(currentItem.itemType)

func _check_using_tool(currentItem):
	if not currentItem:
		return false
	
	var isHoe = currentItem.itemType == ITEM_BAR_ITEM.ITEM_TYPES.HOE 
	var isWateringCan = currentItem.itemType == ITEM_BAR_ITEM.ITEM_TYPES.WATERING_CAN
	var hasTool = isHoe or isWateringCan
	
	return hasTool

func _use_tool(toolType: ITEM_BAR_ITEM.ITEM_TYPES):
	onAction = true
	set_physics_process(false)
	
	animation_player.play("1H_Melee_Attack_Chop")
	await animation_player.animation_finished
	
	onAction = false
	set_physics_process(true)
	
	lastRaycastCollision.tool_interaction(toolType)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if ray_cast_3d.is_colliding():
		_on_raycast_collision()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	var direction = (third_person_camera.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _on_raycast_collision():
	var collider = ray_cast_3d.get_collider()

	if lastRaycastCollision and lastRaycastCollision.has_method("set_selection"):
		lastRaycastCollision.set_selection(false)

	if collider.has_method("set_selection"):
		collider.set_selection(true)
	
	lastRaycastCollision = collider

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
