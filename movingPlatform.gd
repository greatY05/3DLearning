extends Node3D
class_name movingPlatform

@onready var tween : Tween
@onready var raycast
func _ready() -> void:
	raycast = RayCast3D.new()
	raycast.collision_mask = 1
	add_child(raycast)
	for i in get_children():
		for j in i.get_children():
			if j.is_class("MeshInstance3D"):
				boxshapeSize = j.mesh.size
				print(boxshapeSize)
	#move()

var boxshapeSize : Vector3
@export var direction : int =1
var targetPoint : Vector3
@export var wallOffset : float = 1
var currentSpeed : float
@export var targetSpeed : float = 10 #max speed/target speed for a platform
@export var accelerationSpeed : float = 0.5 #how fast to get to max speed
var targetFound : bool = false
var decelSpeed : float = 10

var raycast_length : float
func _physics_process(delta: float) -> void:
	raycast_length = boxshapeSize.x 
	raycast.target_position = Vector3(raycast_length * direction,0,0)
	raycast.force_raycast_update()
	
	if targetFound:
		detectionMovement(delta)
	else:
		normalMovement(delta)
		collisionChecker()

func normalMovement(delta):
	currentSpeed = move_toward(currentSpeed, targetSpeed, 2)
	position.x += currentSpeed * direction * delta

func detectionMovement(delta):
	var distance = abs(targetPoint.x - position.x)
	var decelaration = (currentSpeed*currentSpeed) / (2 * distance)
	currentSpeed = move_toward(currentSpeed, 0, decelaration * decelSpeed * delta)
	position.x += currentSpeed * direction * delta
	
	
	if abs(currentSpeed) < 0.5:
		reverseDir()

func collisionChecker():
	if raycast.is_colliding() and raycast.get_collider().name != "player":
		var collisionPoint = raycast.get_collision_point()
		targetPoint.x = collisionPoint.x - (direction * (boxshapeSize.x + wallOffset))
		targetFound = true

func reverseDir():
	direction *= -1
	currentSpeed = 0
	targetFound = false

#func move():
	#raycast.target_position = Vector3(boxshapeSize.x + 5 * direction,0,0)
	#raycast.force_raycast_update()
	#tween = create_tween().set_parallel()
	#if not raycast.is_colliding():
		#tween.tween_property(self, "position:x", position.x + 5, 1).set_ease(Tween.EASE_OUT)
	#else:
		#var collisionPoint = raycast.get_collision_point()
		#var distanceToPoint = collisionPoint - position
		##tween.tween_property(self, "position:x", position.x + distanceToPoint.x + boxshapeSize.x, 1).set_ease(Tween.EASE_OUT)
		#direction *= -1
	#if raycast.is_colliding():
		#if raycast.get_collider().class == "CollisionShape3D":
			#print("hit")
		#tween.tween_property(self, "position:x", raycast.get_collision_point().x - boxshapeSize.x, 5).set_ease(Tween.EASE_OUT)
		#direction *= -1
		#print(raycast.target_position, raycast.get_collision_point().x)
	#else:
		#tween.tween_property(self, "position:x", position.x + raycast.target_position.x, 5)
		#print("nothing found", raycast.target_position.x)

	#tween.finished.connect(_on_tweenloop_finished)

## TO DO:: platforms flipping but not moving
