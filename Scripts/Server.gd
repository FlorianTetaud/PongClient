extends Node

var LoggingInfo_NODE = preload("../Scenes/LoggingInfo.tscn")
var LoggingInfo = LoggingInfo_NODE.instance()

var Lobby_NODE = preload("../Scenes/Lobby.tscn")
var Lobby = Lobby_NODE.instance()

var gameInstance_NODE = preload("../Scenes/GameInstance.tscn")
var gameInstance = gameInstance_NODE.instance()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var peer =  NetworkedMultiplayerENet.new()
#var ip = "pixpong.ddns.net"
#var ip = "5.48.149.215"
var ip = "127.0.0.1"
var port = 1025;

var player_name =""
var list_of_players =""

var connected = false

#datas from server :
var ball_info_json  = \
	"{"\
	+"\"dx\" : \""  + str(0)+"\","\
	+"\"dy\" : \""  + str(0)+"\","\
	+"\"playing\" : \""  + str(false)+"\","\
	+"\"deltatime\" : \""  + str(0)+"\""\
	+"}"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LoggingInfo)
	peer.create_client(ip,port)
	get_tree().set_network_peer(peer)
	peer.connect("connection_failed",self, "_OnConnectionFailed")
	peer.connect("connection_succeeded",self,"_OnConnect")
	pass # Replace with function body.

func _process(delta):
	_control()


func _on_Timer_Ping_timeout():
	ping_server()



func _OnConnectionFailed():
	print("connection failed to server")
	$LoggingInfo/LogInfo.text = "connection failed to server"
	connected = false
func _OnConnect():
	print("sucess to connect to server")
	$LoggingInfo/LogInfo.text = "sucess to connect to server"
	connected = true
	

	
########################### SERVER PING ########################################
var time_start = 0
var ping = false
var pingrequest = false
var ping_value : float =  999;
var ping_value_tmp : float = 0.00000

func ping_server():
	if(!ping and connected and !pingrequest):
		pingrequest = true
		time_start = OS.get_ticks_msec()
		rpc_id(1,"ping")
	else:
		if(ping):
			pingrequest =false
			ping =false
			ping_value = OS.get_ticks_msec() - time_start
			$Ping.text = "ping = "+str(ping_value);
			print (ping_value)

remote func _return_ping():
	ping = true
	ping_server()
	
###########################SERVER LOBBY########################################
func _Enter_lobby():
	rpc_id(1,"_Player_Enter_Lobby",player_name)
	remove_child(LoggingInfo)
	add_child(Lobby)
	
remote func _return_list_of_players(list):
	list_of_players = list
	if(get_node_or_null("Lobby")):
		$Lobby._write_player_list(list_of_players)
	
func _automatch():
	rpc_id(1,"_automatch")
	
remote func _start_match():
	remove_child(Lobby)
	add_child(gameInstance)
###########################GAME INSTANCE########################################

func _server_input_event(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if(get_node_or_null("GameInstance")):
					rpc_id(1,"_StartGame")
				
func _control():
	var GameInstance = get_node_or_null("GameInstance")
	if(GameInstance):
		_ReturnPlayersControl(GameInstance.KEY_UP_pressed,GameInstance.KEY_DOWN_pressed)
		
func get_ball_position():
	return ball_info_json

remote func _return_ball_hit(player_number):
	$GameInstance/Ball._ball_hit_player(player_number)

func _ReturnPlayersControl(KEY_UP_pressed,KEY_DOWN_pressed):
	rpc_unreliable_id(1,"_ReturnPlayersControl",str(KEY_UP_pressed),str(KEY_DOWN_pressed))

remote func _return_score_info(p1score,p2score):
	if(get_node_or_null("GameInstance")):
		$GameInstance.update_score(p1score,p2score);

remote func _return_DisplayMessage(message,visible):
	if(get_node_or_null("GameInstance")):
		$GameInstance.display_message(message,visible)

var last_time_return_server_ball_info = 0
var get_first_deltatime= false
var time_return_server_ball_info1
var time_return_server_ball_info

remote func _return_server_ball_info(time,dx,dy,playing):
	if(!get_first_deltatime):
		time_return_server_ball_info1 = time
		get_first_deltatime = true
	time_return_server_ball_info =  time - time_return_server_ball_info1
		
	if(_drop(time_return_server_ball_info,last_time_return_server_ball_info)):
		var deltatime = time_return_server_ball_info - last_time_return_server_ball_info 
		ball_info_json = \
		"{"\
		+"\"dx\" : \""  + str(dx)+"\","\
		+"\"dy\" : \""  + str(dy)+"\","\
		+"\"playing\" : \""  + str(playing)+"\","\
		+"\"deltatime\" : \""  + str(deltatime)+"\""\
		+"}"
		last_time_return_server_ball_info = time_return_server_ball_info
		
remote func _return_players_position(p1x,p1y,p2x,p2y):
	if(get_node_or_null("GameInstance")):
		$GameInstance._setVariable(int(p1x),int(p2x),int(p1y),int(p2y))

########################### CUSTOM FUNCTIONS ########################################
func _drop(time, last_time):
	if(time>last_time):
		return true
	else:
		return false
