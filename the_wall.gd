extends Node3D


##trasnfering this all as an independent on the camera: send a signal to the camera with what node it should follow
@onready var anchor: Node3D = $cameraLock/cameraAnchorPlatforms

func _on_camera_lock_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.emit_signal("lockonCamera", anchor)

func _on_camera_lock_body_exited(body: Node3D) -> void:
	if body.name == "player":
		body.emit_signal("lockonCamera", body.get_node("cameraPoint"))


##old script that handled the transition locally, now it works on the cameras script independently 
## vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#@onready var anchor: Node3D = $cameraLock/cameraAnchorPlatforms
#@onready var lockBox: CollisionShape3D = $cameraLock/lockArea
#
#@onready var character : CharacterBody3D
#var camera : Camera3D
#var pivot 
#
#var oldDirection
#var tween : Tween
#func _on_camera_lock_body_entered(body: Node3D) -> void:
	#if body.name == "player":
		#character = body
		#print("entered")
		#if body.get_node("cameraPoint/pivot"):
			#pivot = body.get_node("cameraPoint/pivot")
			#pivot.reparent(anchor)
			#if tween:
				#tween.kill()
			#tween = body.create_tween().set_parallel(true)
			#tween.tween_property(pivot, "position", Vector3.ZERO, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			#tween.tween_property(pivot, "rotation:y", anchor.rotation.y , 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			#tween.tween_property(pivot.get_node("innerPivot"), "rotation:x", anchor.rotation.x , 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			#
#
#var posInsideBox
#func _process(delta: float) -> void:
	#if character:
		#posInsideBox = get_relative_position(character.global_position)
		##print(posInsideBox)
		#if abs(posInsideBox.y) > lockBox.shape.size.y/2 - 4:
			#print("at the top")
			##tween = character.create_tween()
			##tween.tween_property(pivot, "position", Vector3(pivot.position.x, pivot.position.y + 1, pivot.position.z), 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		#if posInsideBox.x > 3: 
			#print("big")
			#exitRotation = Vector3.UP#exitAngles["left"]
		##print("character positon: ", character.position.y, "collision size heigh? ", lockBox.shape.size.y)
		##if character.position.y >= lockBox.shape.size.y:
			##print("height reached")
#
##gets the player location inside a relative box
#func get_relative_position(characterPos : Vector3): #kinda nice to detect corners of an area but need to do it with the camera for this usecase
	#var localPos = lockBox.global_transform.inverse() * characterPos
	#return localPos
#var exitAngles := {"left" : Vector3.LEFT, "back" : Vector3.BACK, "forward" : Vector3.FORWARD, "right" : Vector3.RIGHT}
#var exitRotation : Vector3
#
#var placeholder 
#var springLock
#func _on_camera_lock_body_exited(body: Node3D) -> void:
	#if body.name == "player":
		#if pivot:
			#await body.is_on_floor()
			#placeholder = body.get_node("cameraPoint")
			##springLock = placeholder.spring_length * Vector3(0,0,1) #instead the camera should look towards direction (where the player is heading)
			##the camera system sucks ass replace it
			#
			#pivot.reparent(placeholder)
			#tween.kill()
			#tween = body.create_tween().set_parallel(true)
			#tween.tween_property(pivot, "position", placeholder.position, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			##tween.tween_property(pivot, "rotation:y", exitRotation.y, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			##tween.tween_property(pivot.get_node("innerPivot"), "rotation:x", exitRotation.x, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			#character = null
			#
