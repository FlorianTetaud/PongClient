extends Node2D

onready var ballinfo
onready var ball_info_json 

func _ready():
	pass

const FILTER_SIZE = 5
var x_1
var x_2
var y_1
var y_2

var currentT
var lastT =0.0

var accx = 0.0
var accy = 0.0
var vx = 0.0
var vx_p = 0.0
var vx_1 = 0.0
var vy = 0.0
var vy_p = 0.0
var vy_1 = 0.0
var deltatime_1 = 0.0
var counter = 0
var dx_dt = 0.0
var dy_dt = 0.0
var dx_dt_p = 0.0
var dy_dt_p = 0.0

var _array_px =[]
var _array_py =[]
var _compute_counter

func _process(delta):
	var serverNode =  get_tree().get_root().get_node("pong/Server")
	ball_info_json = serverNode.get_ball_position()
	ballinfo = JSON.parse(ball_info_json).result
	_update_position(float(ballinfo["dx"]),float(ballinfo["dy"]),float(ballinfo["deltatime"]),delta)
		
func _update_position(x,y,deltatime,delta):
	print("x  server = " + str(x))
	print("deltatime= " + str(deltatime))
	
	if !Helpers.convert_string_to_bool(ballinfo["playing"]):
		counter = 0
		self.position = Vector2(x,y)
		_compute_counter = 0
		_array_px = []
		_array_py = []
		for i in range(FILTER_SIZE):
			_array_px.insert(i,0)
			_array_py.insert(i,0)
#		self.linear_velocity.x=0.0
#		self.linear_velocity.y=0.0
		print("x helper=" + str(self.get_position().x))
	else:
		if(deltatime > 0.0):
			if counter<=2:
				counter +=1
			else:
				print("x=" + str(self.get_position().x))
				dx_dt_p = ((x - self.get_position().x))/2 ; dy_dt_p = ((y - self.get_position().y))/2
				dx_dt = (x - x_1) ; dy_dt = (y - y_1)
				vx = dx_dt/deltatime ; vy = dy_dt/deltatime
#				vx_p = min(dx_dt_p/deltatime,vx) ; vy_p = min(vy,dy_dt_p/deltatime) ; 
				vx_p = dx_dt_p/deltatime ; vy_p = dy_dt_p/deltatime 

				print("dx_dt_p=" + str(dx_dt_p))
				print("dx_dt=" + str(dx_dt))
				print("vx_p=" + str(vx_p))
	#			vx_1 = (x_1-x_2)/deltatime_1 ; vy_1 = (y_1 -y_2)/deltatime_1 ; 
	#			accx = (vx - vx_1)/deltatime ; accy = (vy - vy_1)/deltatime ; 
			x_2=x_1
			y_2=y_1
			x_1 = x
			y_1 = y
			vx_1 = vx
			deltatime_1 = deltatime
		_compture_position(delta)


func _compture_position(delta):
	_compute_counter += 1
	if _compute_counter>=FILTER_SIZE:
		_compute_counter = 0
		_array_px[0] = vx_p*delta*1000
		_array_py[0] = vy_p*delta*1000
	else:
		_array_px[_compute_counter] = vx_p*delta*1000
		_array_py[_compute_counter] = vy_p*delta*1000
	self.position.x += _somme(_array_px)
	self.position.y +=  _somme(_array_py)
	print("x=" + str(.get_position().x))

func _somme(array):
	var som = 0.0
	for i in array:
		som+=i
	return som/array.size()

func _ball_hit_player(PlayerNumber):
	$PaddleHitSound.play()
	pass # Replace with function body.
