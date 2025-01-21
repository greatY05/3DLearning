extends CharacterBody3D

#base script vars
const SPEED = 10.0
var tween : Tween

@export var deceleration := 0.85
var gravity := Vector3(0,-13,0)
@export var mass := 1.0
@onready var wall_coll: Area3D = $wallColl

#new jump vars
@export var jumpHeight := 2
@export var jumpPeakTime : float = 2
@export var jumpDescentTime : float
@onready var jumpVel := ((2.0 * jumpHeight) / jumpPeakTime) 
@onready var jumpGrav := -((-2.0 * jumpHeight) / pow(jumpPeakTime, 2)) 
@onready var fallGrav := -((-2.0 * jumpHeight) /pow(jumpDescentTime, 2)) 

var jumpQueue : bool = false
#references
@onready var pivot: Node3D = $cameraPoint/pivot
@onready var camera: Camera3D = %Camera3D
@onready var springArm: SpringArm3D = $cameraPoint/pivot/innerPivot/SpringArm3D
@onready var body: MeshInstance3D = $body
@onready var stateChart: StateChart = $states/StateChart

@onready var direction
#states - replaced for the state machine
#enum states {idle, walking, air, wall}
#var state: states = states.idle

#checks
var jumped : bool = false #checks if we jumped yet

func _physics_process(delta: float) -> void:
	#var forward = -camera.transform.basis.x.normalized()
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cameraForward = camera.global_transform.basis.z * Vector3(1,0,1).normalized()
	direction = (cameraForward * input_dir.y + camera.global_transform.basis.x * input_dir.x).normalized()
	
	#velocity.x = move_toward(velocity.x, direction.x * SPEED, deceleration/2) if direction else move_toward(velocity.x, 0, deceleration)
	#velocity.z = move_toward(velocity.z, direction.z * SPEED, deceleration/2) if direction else move_toward(velocity.z, 0, deceleration)
	
	#velocity = Vector3(move_toward(velocity.x, direction.x * SPEED, deceleration/2), velocity.y, 
	#move_toward(velocity.z, direction.z * SPEED, deceleration/2)) if direction else Vector3(move_toward(velocity.x, 0, deceleration), velocity.y,
	#move_toward(velocity.z, 0, deceleration))
	
	stateChart.set_expression_property("direction", direction)
	stateChart.set_expression_property("isOnFloor", is_on_floor())
	stateChart.set_expression_property("isOnWall", is_on_wall_only())
	stateChart.set_expression_property("upVelocity", velocity.y)
	
	#stateManager(direction)
	#if state != oldState:
		#pass#print("State changed from %s to %s" % [states.keys()[oldState], states.keys()[state]])
	#oldState = state
	
		#checks if jump is held and upwards
	#var slowfall: bool = velocity.y > 0 and Input.is_action_pressed("ui_accept") and not is_on_floor() and state == states.air
	#print(velocity.y)
	#if state == states.idle:
		#jumped = false
		#if jumpQueue: #jump buffer
			#if is_on_floor():
				#jumpAction()
			#elif is_on_wall():
				#jump(direction)
			#jumpQueue = false
	#elif state == states.walking:
		#jumped = false
		#if jumpQueue: #jump buffer
			#if is_on_floor():
				#jumpAction()
			#elif is_on_wall_only():
				#jump(direction)
			#jumpQueue = false
	#elif state == states.air:
		#pass#print("jumping") if velocity.y > 0 else print("falling")
		#velocity += gravity * delta * (jumpGrav if slowfall else fallGrav)
		#if $foxTimer.is_stopped() and not jumped: $foxTimer.start() #coyote jump
	#elif state == states.wall:
		#mass = 0.5
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
		#velocity.y = -0.9
		#if Input.is_action_just_pressed("ui_accept"):
			#jump(direction)

	#move_and_slide()
	#rotates the body(visual)
	#rotateCharacter(direction, delta)
#var oldState = states.idle #for debugging current state

#air movement
func _on_in_air_state_physics_processing(delta: float) -> void:
	var slowfall: bool = velocity.y > 0 and Input.is_action_pressed("ui_accept") and not is_on_floor()
	pass#print("jumping") if velocity.y > 0 else print("falling")
	velocity += gravity * delta * (jumpGrav if slowfall else fallGrav) 
	#if $foxTimer.is_stopped() and not jumped: $foxTimer.start() #coyote jump

#walking
func _on_walking_state_physics_processing(delta: float) -> void:
	pass#print("Wow im walking")

var platVel
#for general movement handling
func _on_movement_state_physics_processing(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cameraForward = camera.global_transform.basis.z * Vector3(1,0,1).normalized()
	direction = (cameraForward * input_dir.y + camera.global_transform.basis.x * input_dir.x).normalized()
	
	#velocity.x = move_toward(velocity.x, direction.x * SPEED, deceleration/2) if direction else move_toward(velocity.x, 0, deceleration)
	#velocity.z = move_toward(velocity.z, direction.z * SPEED, deceleration/2) if direction else move_toward(velocity.z, 0, deceleration)
	velocity = Vector3(move_toward(velocity.x, direction.x * SPEED, deceleration), velocity.y, 
	move_toward(velocity.z, direction.z * SPEED, deceleration)) if direction else Vector3(move_toward(velocity.x, 0, deceleration), velocity.y,
	move_toward(velocity.z, 0, deceleration))
	platVel = get_platform_angular_velocity()
	print(platVel)
	if platVel:
		velocity.x = platVel.x
		velocity.z = platVel.z
	
	
	move_and_slide()
	rotateCharacter(direction, delta)


func _on_ground_state_entered() -> void:
	jumped = false
#starts coyote timer if possible
func _on_ground_state_exited() -> void:
	if $foxTimer.is_stopped() and not jumped: 
		$foxTimer.start() 
		print("started coyote jump")

func _on_wall_state_physics_processing(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cameraForward = camera.global_transform.basis.z * Vector3(1,0,1).normalized()
	direction = (cameraForward * input_dir.y + camera.global_transform.basis.x * input_dir.x).normalized()
	
	#6velocity += gravity * delta * 0.1
	
	velocity.x = 0
	velocity.z = 0
	velocity.y = maxf(velocity.y, -0.8)  # Limit maximum fall speed on wall
	
	
	#mass = 0.02
	#velocity.x = move_toward(velocity.x, 0, 0.1)
	#velocity.z = move_toward(velocity.z, 0, 0.1)
	#if velocity.y < 0:
		#velocity.y = move_toward(velocity.y, -0.2, 0.1)
	#velocity.x = 0
	#velocity.z = 0
	#velocity.y = -0.2




func _jumping_physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") or jumpQueue:
		#jumpQueue = true
		jump()



func jump():
	if jumped == false or is_on_wall():
		jumpAction()
	
	if not jumpQueue:
		$reverseFox.start()
		jumpQueue = true


func jumpAction():
	if is_on_wall():
		print("walljump")
		velocity = Vector3(get_wall_normal().x * wallPushback, jumpVel*1.1, get_wall_normal().z * wallPushback)
		print(velocity.y)
		
		
	else:
		velocity.y = jumpVel
		jumped = true
		print("jump")

const wallPushback := 10

#wall jump dont work rn


#signal manager
signal lockonCamera(target) ##sends signal to the camera script to lock on a pivoting point



#timers
func _on_fox_timer_timeout() -> void:
	jumped = true
	print("out")

func _on_reverse_fox_timeout() -> void:
	jumpQueue = false

#rotates the body model
var lastMove : Vector3
func rotateCharacter(direction, delta):
	if direction.length() > 0.3:
		lastMove = direction
		var targetAngle := Vector3.BACK.signed_angle_to(lastMove, Vector3.UP)
		body.global_rotation.y = lerp_angle(body.rotation.y, targetAngle, SPEED * delta)

#unfunctional
func stateManager(direction):
	pass#jump states
	#if not is_on_floor():
		#if is_on_wall():
			#state = states.wall
		#else:
			#state = states.air 
	##moving states
	#if direction:
		#if is_on_floor():
			#state = states.walking
	#elif is_on_floor(): 
		#state = states.idle

#ensures that if we jumped into the air, it wont start the coyote timer (i prefer that over
#starting with no coyote and transitioning to coyote because it is a lost frame where you cant coyote) 
func _on_air_state_entered() -> void:
	if jumped == true:
		stateChart.send_event("toCantjump")
