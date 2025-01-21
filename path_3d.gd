extends Path3D



@export var move_speed = 4
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PathFollow3D.progress += move_speed *delta
