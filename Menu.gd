extends MarginContainer

const SERVER_PORT = 2024
const MAX_PLAYERS = 2

func _on_StartGameButton_pressed():
	Global.startMultiplayerGame()

func _on_play_pressed():
	var my_player = preload("res://Ship.tscn").instance()
	Global.playersToSpawn = [my_player]
	Global.startGame()


func _on_ServerButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer


func _on_JoinButton_pressed():
	var ip = $VBoxContainer/IpEdit.text
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, SERVER_PORT)
	get_tree().network_peer = peer


