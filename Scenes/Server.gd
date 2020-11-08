extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var peer =  NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1000;

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
	_fetch_server_ball_info()
	pass

func _OnConnectionFailed():
	print("connection failed")
	
func _OnConnect():
	print("sucess to connect")
	
func _server_input_event(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			print(event)
			rpc_id(1,"_StartGame")
			
func _fetch_server_ball_info():
	rpc_id(1,"_fetch_server_ball_info")
	
remote func _return_ball_info(dx,dy,playing):
	ball_info_json = \
	"{"\
	+"\"dx\" : \""  + str(dx)+"\","\
	+"\"dy\" : \""  + str(dy)+"\","\
	+"\"playing\" : \""  + str(playing)+"\""\
	+"}"
	
func get_ball_position():
	return ball_info_json
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
