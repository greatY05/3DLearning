extends MeshInstance3D

#signal spikeUpGround
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#@onready var player: CharacterBody3D = $"../CharacterBody3D"
#
#
#var oldDist
#var distanceFromBall
#var distToPrecent 
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#
	#distanceFromBall = self.position.distance_to(player.position)
	#if distanceFromBall <= 10 and distanceFromBall != oldDist:
		#distToPrecent = distanceFromBall 
		#spikeUpGround.emit(2 /distToPrecent, 1*distToPrecent,0.5)
		##print(distToPrecent)
	#oldDist = distanceFromBall
