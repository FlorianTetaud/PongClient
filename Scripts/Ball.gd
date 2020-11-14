extends RigidBody2D

var dx = 100
var dy = 0
var speed = 150
var y_range = 100
var playing = false


class Ball_Data:
	var dx : int
	var dy : int
	var speed : int
	var y_range : int
	var playing : bool

func _ready():
	pass

func _physics_process(delta):
	var serverNode =  get_tree().get_root().get_node("pong/Server")
	var ball_info_json = serverNode.get_ball_position()
	var ballinfo = JSON.parse(ball_info_json).result
	self.position.x = int(ballinfo["dx"])
	self.position.y = int(ballinfo["dy"])
#		change_dy_on_wall_hit()z
#		self.rotation = 0
#		self.linear_velocity = Vector2(dx, dy) * delta * speed
#
#
#func _ball_hit_paddle(_body):
#	dx *= -1
#	dy = rand_range(-y_range, y_range)
#	if speed < 300:
#		speed += 5
#	if y_range < 200:
#		y_range += 5
#
#
#
#func change_dy_on_wall_hit():
#	if self.position.y <= 0:
#		dy = rand_range(0, y_range)
#	if self.position.y >= 600:
#		dy = rand_range(-y_range, 0)
#
#
#func set_playing(_playing):
#	playing = _playing


func _ball_hit_player(PlayerNumber):
	$PaddleHitSound.play()
	pass # Replace with function body.
