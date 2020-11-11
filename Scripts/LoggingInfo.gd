extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	var server = get_parent()
	if($Name.text != "" and server.connected):
		server.player_name = $Name.text
		server._Enter_lobby()
	else:
		if($Name.text ==""):
			$LogInfo.text = $LogInfo.text + "Enter the game with not empty name !\n "
		if(!server.connected):
			$LogInfo.text = $LogInfo.text + " Wait server connection ! \n"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
