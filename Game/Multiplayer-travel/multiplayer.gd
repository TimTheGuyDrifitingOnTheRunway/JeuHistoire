extends Node
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var world_scene : PackedScene
var username = str('none')
signal user_send(name)
var player_list = []



	
	
func _on_host_pressed():
	if $UI/VBoxContainer/username.text !='':
		peer.create_server(135)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		multiplayer.peer_disconnected.connect(_remove_player)
		_add_player()
		start_game()
	else:
		OS.alert('You need ton enter an username')
		
func _add_player(id = 1):
	
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	# gère la liste des joueurs
	player_list.append(player)
	comon_data.global_player_list[id] = player
	print(comon_data.global_player_list)
	
		
func _remove_player(id = 1):
	var player = comon_data.global_player_list[id] # on recupère le joueur correspondant a l'id
	comon_data.global_player_list.erase(id)# on suprime l'entrée correspondant au joueur dans le tableau
	for child in get_children():
		if child== player:
			var path = child.get_path() # on recupère son path
			print("removing on all client : ", id, "with path : ", path)
			del_player.rpc(path)# on l'envoi a tous les clients
	
	
@rpc("authority", "call_local")
func del_player(player_path):
	var player = get_node(player_path)# on, récupère le node asocié au path
	#print("deleting ", player, " at path : ", player_path)
	player.queue_free()# on le suprime
	
func _on_join_pressed():
	multiplayer.connection_failed.connect(_reset_connexion)#bind levenemt 
	if $UI/VBoxContainer/username.text !='':
		if $UI/VBoxContainer/HBoxContainer/adress.text !='':
			peer.create_client($UI/VBoxContainer/HBoxContainer/adress.text, 135)#connexion
			multiplayer.multiplayer_peer = peer
			if peer.get_peer(1)!=null:
				start_game()
			else:
				OS.alert('Connexion failed \n invalid adress')
		else:
			OS.alert('You need to enter an adress')
	else:
		OS.alert('You need to enter an username')
	
func start_game():
	comon_data.username=$UI/VBoxContainer/username.text #synchronise le pseudo
	$UI.hide()
	$world.show()
	
func _reset_connexion():
	OS.alert('connexion failed')
	for child in get_children():#suprimme les itérations des jouerus
		child.queue_free()
	if get_tree().has_network_peer():
		get_tree().network_peer= null
	$world.hide()
	$UI.show()
		
	
