extends MeshInstance3D

#signal spikeUpGround
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass
#
#var tween : Tween 
#
#func setShaderValueHeight(value: float):
	#mesh.material.set_shader_parameter("height_scale", value)
#
	#curValueHeight = value
#
#func setShaderValueSpeed(_speed : float):
	#mesh.material.set_shader_parameter("waveSpeed", speed)
	#curValueSpeed = speed
	#pass
#
#var curValueHeight = 0.0
#var curValueSpeed = 0.0
#func _on_spike_up_ground(value, waveSpeed, speed) -> void:
	#tween = create_tween()
	#tween.tween_method(setShaderValueHeight, curValueHeight, value, speed)
	#tween = create_tween()
	#tween.tween_method(setShaderValueSpeed, curValueSpeed, waveSpeed, speed)
	
