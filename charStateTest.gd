extends CharacterBody3D

@onready var repositionTimer: Timer = $reposition
@onready var stateChart: StateChart = $stateManager/StateChart
@export var player : CharacterBody3D
var playerPos : Vector3

func _on_idle_state_entered() -> void:
	print("idle")

func _on_notice_area_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name == "player":
		player = body
	if player:
		print("player entered")
		stateChart.send_event("idleToLooking")

func _on_notice_area_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player = null
	if not player:
		print("player left")
		stateChart.send_event("lookingToIdle")

func _on_looking_state_entered() -> void:
	playerPos = player.global_position
	print("started looking ", playerPos)
	repositionTimer.start()



func _on_looking_state_physics_processing(delta: float) -> void:
	var tween := create_tween()
	#print("looking for ", player.name)
	if player:
		tween.tween_property(self, "position", playerPos, 2)
		#position = lerp(position, playerPos, 10)
	
	if repositionTimer.timeout:
		repositionTimer.start()
	move_and_slide()

func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.name == "player":
		stateChart.send_event("waitingForAttack")
		
		body.position
		

var pushbackDir
func _on_attacking_state_entered() -> void:
	print("attacking")
	if player:
		pushbackDir = (player.position - position).normalized()
		print(pushbackDir)
		player.velocity = Vector3(pushbackDir.x, 1, pushbackDir.z)


func _on_reposition_timeout() -> void:
	if player:
		playerPos = player.position
		print("repositioned player location")
