extends Node2D

const startingPositions = [Vector2(1000,1000),Vector2(1200,1200)]

func _ready():
	print("Setting up world")
	for idx in Global.playersToSpawn.size():
		var player = Global.playersToSpawn[idx]
		var position = startingPositions[idx]
		player.global_position = position
		add_child(player)
