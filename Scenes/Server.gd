extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var peer =  NetworkedMultiplayerENet.new()
var ip = "pixpong.ddns.net"
var port = 1025;

#datas from server :
var ball_info_json  = \
	"{"\
	+"\"dx\" : \""  + str(0)+"\","\
	+"\"dy\" : \""  + str(0)+"\","\
	+"\"playing\" : \""  + str(false)+"\""\
	+"}"

# Called when the node enters the scene tree for the first time.
func _ready():
	peer.create_client(ip,port)
	get_tree().set_network_peer(peer)
	peer.connect("connection_failed",self, "_OnConnectionFailed")
	peer.connect("connection_succeeded",self,"_OnConnect")
	pass # Replace with function body.

func _process(delta):
	var pongnode = get_parent()
	_ReturnPlayersControl(pongnode.KEY_UP_pressed,pongnode.KEY_DOWN_pressed)
	

func _OnConnectionFailed():
	print("connection failed")
	
func _OnConnect():
	print("sucess to connect")
	
func _server_input_event(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			rpc_id(1,"_StartGame")
	
remote func _return_server_ball_info(dx,dy,playing):
	ball_info_json = \
	"{"\
	+"\"dx\" : \""  + str(dx)+"\","\
	+"\"dy\" : \""  + str(dy)+"\","\
	+"\"playing\" : \""  + str(playing)+"\""\
	+"}"

remote func _return_players_position(p1x,p1y,p2x,p2y):
	get_parent()._setVariable(int(p1x),int(p2x),int(p1y),int(p2y))

func _ReturnPlayersControl(KEY_UP_pressed,KEY_DOWN_pressed):
	rpc_unreliable_id(1,"_ReturnPlayersControl",str(KEY_UP_pressed),str(KEY_DOWN_pressed))
	pass
	
func get_ball_position():
	return ball_info_json
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
