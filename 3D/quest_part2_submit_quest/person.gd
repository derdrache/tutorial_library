#extends CharacterBody3D
#class_name Person
#
#@export var person: GameManager.PERSON
#
#var inRange
#
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("interaction") and inRange:
		#_talk()
		#
#func _talk():
	#var ownDoneQuest = GameManager.own_quest_done(person)
	#if ownDoneQuest:
		## Quest done dialog
		#GameManager.quest_done(ownDoneQuest)
	#else:
		## start normal Dialog
		#GameManager.talk_with(person)
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#inRange = true
#
#
#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#inRange = false
