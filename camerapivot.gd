extends Node3D

@export_range(10, 100) var sensitivity := 100
@onready var camera: Camera3D = %Camera3D
@onready var springArm: SpringArm3D = $innerPivot/SpringArm3D
var lengthRoll := 0.01

func _input(event: InputEvent) -> void:
	if find_parent("cameraPoint"):
		var cameraLock := (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
		
		if cameraLock:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				$innerPivot.rotation.x -= event.screen_relative.y / sensitivity
				rotation.y -= event.screen_relative.x / sensitivity 
				$innerPivot.rotation.x = clamp($innerPivot.rotation.x, deg_to_rad(-50), deg_to_rad(50))
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		if event.is_action("scroll out") and springArm.spring_length <= 2.5:
			tween = create_tween().set_parallel(true)
			tween.tween_property(springArm, "spring_length", springArm.spring_length + lengthRoll, 1).set_trans(Tween.TRANS_BACK)
			tween.tween_property(springArm, "position", springArm.position + Vector3(0,lengthRoll,0), 1)
			#springArm.position.y = lerp(springArm.position.y ,springArm.position.y + lengthRoll, 1)
			#springArm.spring_length += 0.1
			#springArm.spring_length = lerp(springArm.spring_length, springArm.spring_length + 0.1, 1)
		if event.is_action("scroll in") and springArm.spring_length >= 0.2:
			tween = create_tween().set_parallel(true)
			tween.tween_property(springArm, "spring_length", springArm.spring_length - lengthRoll, 1).set_trans(Tween.TRANS_BACK)
			tween.tween_property(springArm, "position", springArm.position - Vector3(0,lengthRoll,0), 1)
			#springArm.position.y = lerp(springArm.position.y ,springArm.position.y - lengthRoll, 1)
			#springArm.spring_length = lerp(springArm.spring_length, springArm.spring_length - 0.1, 1)
  
var tween: Tween

##manager of camera setting into set pivoting points

func _on_lockon_camera(target: Variant) -> void:
	print("pass")
	if tween:
		tween.kill()
	reparent(target)
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector3.ZERO, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation:y", target.rotation.y , 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self.get_node("innerPivot"), "rotation:x", target.rotation.x , 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
