extends "res://Scenes/Characters/Character.gd"

var motion=Vector3()

const UP=Vector3(0,1,0)

const SPEED=10 

var movement_state=0

var mouse_sensitivity=1200
const min_blend_speed=0.125
const blend_to_run=0.075
const blend_to_idle=0.1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation=h_camera_rotation(-event.relative.x/mouse_sensitivity)
		$Camera.rotation=v_camera_rotation(-event.relative.y/mouse_sensitivity)
	if(Input.is_action_just_pressed("fire")):
		try_to_fire()
func _physics_process(delta):
	move()
	animate()

func move():
	var movement_dir=get_2d_movement_dir()
	var direction_to_cam=Vector3.ZERO
	var camera_xform=$Camera.global_transform
	direction_to_cam-=camera_xform.basis.z.normalized()*movement_dir.x 
	direction_to_cam+=camera_xform.basis.x.normalized()*movement_dir.y
	direction_to_cam.y=0
	motion =direction_to_cam
	move_and_slide(motion*SPEED,UP)
	
func get_2d_movement_dir():
	var x=Input.get_action_strength("forward")-Input.get_action_strength("back")
	var z=Input.get_action_strength("right")-Input.get_action_strength("left")
	var movement_direction=Vector2(x,z)
	if(movement_direction!=Vector2(0,0)):
		face_forward(x,z)
	return movement_direction.normalized()
func face_forward(x,z):
	get_node("Armature").rotation.y=atan2(x,z)-(PI/2)

func animate():
	if((motion*SPEED).length()>min_blend_speed):
		movement_state+=blend_to_run
	else:
		movement_state-=(blend_to_idle)
	movement_state=clamp(movement_state,0,1)
	get_node("Armature/AnimationTree")["parameters/Move/blend_amount"]=movement_state

func h_camera_rotation(camera_rotation):
	return rotation+Vector3(0,camera_rotation,0)


func v_camera_rotation(camera_rotation):
	var rot= $Camera.rotation+Vector3(camera_rotation,0,0)
	rot.x=clamp(rot.x,-PI/8,PI/8)
	return rot
