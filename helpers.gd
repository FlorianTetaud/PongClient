extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func convert_string_to_bool(strg):
	var b_strg : bool = false
	if(strg == "True" or strg == "true"):
		b_strg = true;
	return b_strg
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
