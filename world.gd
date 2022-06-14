class_name Zone extends Node2D


const Player = preload("res://player.tscn")

func _enter_tree():
	var peer = ENetMultiplayerPeer.new()
	
	if not "--client" in OS.get_cmdline_args():
		multiplayer.peer_connected.connect(self.create_player)
		multiplayer.peer_disconnected.connect(self.destroy_player)
		if peer.create_server(12100) != OK:
			print("address in use")
			get_tree().quit(1)
			return

		print('server listening on localhost 12100')
		multiplayer.set_multiplayer_peer(peer)
		#create_player(multiplayer.get_unique_id())
	else:
		peer.create_client("localhost", 12100)
		multiplayer.set_multiplayer_peer(peer)
		print("joining as ", multiplayer.get_unique_id())
	
func create_player(id : int) -> void:
	print("player %d joined" % id)
	var player = Player.instantiate()
	player.name = str(id)
	$Players.add_child(player)

func destroy_player(id : int) -> void:
	$Players.get_node(str(id)).queue_free()
