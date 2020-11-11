extends Node2D

var BALL_NODE = preload("../Scenes/Ball.tscn")
var ball = BALL_NODE.instance()

const DEFAULT_Y = 150

var p1_x = 15
var p1_y = DEFAULT_Y
var p1_score = 0

var p2_x = 975
var p2_y = DEFAULT_Y
var p2_score = 0

var playing = false
var score_event = false
var game_done = false

const P1_WIN = "Player 1 won!"
const P2_WIN = "Player 2 won!"

var KEY_UP_pressed = false;
var KEY_DOWN_pressed = false;
# Called when the node enters the scene tree for the first time.


func _ready():
	set_ball()
	display_message("PRESS SPACEBAR","True")
#	update_score("0","0")



func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		get_parent()._server_input_event(_event)
		#play()


func _process(delta):
	handle_movement_input()
	$Player1.set_paddle_position(p1_x, p1_y)
	$Player2.set_paddle_position(p2_x, p2_y)
	$Ping.text = "Ping : " + str(get_parent().ping_value)


func _setVariable(var1x,var2x,var1y,var2y):
	p1_x=var1x
	p2_x=var2x
	p1_y=var1y
	p2_y=var2y
	pass

func remove_ball():
	remove_child(ball)


func set_ball():
	ball = BALL_NODE.instance()
	add_child(ball)


func handle_movement_input():
	if Input.is_key_pressed(KEY_UP):
		KEY_UP_pressed = true;
		KEY_DOWN_pressed = false;
		return true
	if Input.is_key_pressed(KEY_DOWN):
		KEY_UP_pressed = false;
		KEY_DOWN_pressed = true;
		return true
	KEY_UP_pressed = false;
	KEY_DOWN_pressed = false;
	return false

func update_score(p1_score,p2_score):
	$Player1Score.text = str(p1_score)
	$Player2Score.text = str(p2_score)

func display_message(message,s_visible):
	$DisplayMessage.text = message
	var b_visible  = Helpers.convert_string_to_bool(s_visible)
	$DisplayMessage.visible = b_visible
