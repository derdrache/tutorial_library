extends Node3D

var draggingCollider
var mousePosition
var doDrag = false

func _input(event):
	var intersect
	
	if event is InputEventMouse:
		intersect = get_mouse_intersect(event.position)
		if intersect: mousePosition = intersect.position 
		#snap on collider
		#if intersect: mousePosition = intersect.collider.global_position
		
	if event is InputEventMouseButton:
		var leftButtonPressed = event.button_index == MOUSE_BUTTON_LEFT && event.pressed
		var leftButtonReleased = event.button_index == MOUSE_BUTTON_LEFT && !event.pressed
		
		if leftButtonReleased:
			doDrag = false
			drag_and_drop(intersect)
		elif leftButtonPressed:
			doDrag = true
			drag_and_drop(intersect)


func _process(delta):
	if draggingCollider:
		draggingCollider.global_position = mousePosition

func drag_and_drop(intersect):
	if !draggingCollider && doDrag:
		draggingCollider = intersect.collider
	elif draggingCollider:
		draggingCollider = null
	
func get_mouse_intersect(mousePosition):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 1000)
	if draggingCollider: params.exclude = [draggingCollider]
	
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	return result
