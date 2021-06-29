extends Node

var player_info = {}
var my_info = { name = "Johnson Magenta" }
var playersToSpawn = []

func startGame():
	get_tree().change_scene("res://gameScene.tscn")
	print("game started")

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _player_connected(id):
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	player_info.erase(id)

func _connected_ok():
	print("connected to server")
	
func _server_disconnected():
	print("server kick")

func _connected_fail():
	print("connection failed")
	
remotesync func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = info
	
remotesync func pre_configure_game():
	get_tree().set_pause(true)
	var selfPeerID = get_tree().get_network_unique_id()

	Global.playersToSpawn = []

	var my_player = preload("res://Ship.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) 
	Global.playersToSpawn.append(my_player)

	for p in player_info:
		var player = preload("res://Ship.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p) 
		Global.playersToSpawn.append(player)
		
	get_tree().change_scene("res://gameScene.tscn")
	rpc_id(1, "done_preconfiguring")
	
var players_done = []

remotesync func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()
	assert(get_tree().is_network_server())
	#assert(who in player_info)
	assert(not who in players_done)

	players_done.append(who)

	if players_done.size() == player_info.size():
		rpc("post_configure_game")

remotesync func post_configure_game():
	if 1 == get_tree().get_rpc_sender_id():
		get_tree().set_pause(false)

func startMultiplayerGame():
	if not get_tree().is_network_server():
		return
			
	rpc("pre_configure_game")


