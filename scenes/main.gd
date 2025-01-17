extends Node3D

var is_underwater: bool = false:
	set(underwater):
		is_underwater = underwater
		if underwater:
			$Underwater.show()
			($WorldEnvironment.environment as Environment).fog_density = 0.03
		else:
			$Underwater.hide()
			($WorldEnvironment.environment as Environment).fog_density = 0.004

var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

@onready var menu: Control = $MenuControl

func _process(delta):
	$DirectionalLight3D.shadow_enabled=Settings.video_submenu.get_shadows()

func _ready():
	States.game_state = States.GameStates.IN_GAME
	$GUI.hide()

# join multiplayer room
func _on_join_pressed():
	var port = str($MenuControl/Menu/IP/Port.text).to_int()
	var ip = str($MenuControl/Menu/IP/IP.text)
	multiplayer_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	$GUI.show()

# multiplayer host
func _on_host_pressed():
	var port = str($MenuControl/Menu/IP/Port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()
	$GUI.show()

# adds a character
func add_player_character(id=1):
	var character = preload("res://player_character/player_character.tscn").instantiate()
	character.name = str(id)
	add_child(character)
	
