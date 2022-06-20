class_name Player
extends KinematicBody

const MAX_CAMERA_SHAKE = 0.3
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 1
const CAMERA_NORMAL_POS = Vector3(0, 1.8, 0)
const ACCEL_SPRINT = 20
const ACCEL_STEALTH = 3
const ACCEL_ZERO = 0

var health = 100
var speed = 7
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var weight = 1.1
var jump = 5
var crouch_rate = 0.5

var current_weapon_idx
var current_weapon

var _walking = false
var _stealth = false
var _crouching = false
var _leaning = false
var _can_jump = true
var _talking = false

var snap

var cam_accel = 40
var mouse_sensitivity = 0.1

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

var body_normal_height: float
var body_normal_radius: float


onready var body = $Body
onready var feet = $Feet
onready var head = $Head
onready var hand = $Head/Camera/Hand
onready var ui = $UI
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast
onready var anim_player = $AnimationPlayer 
onready var weapon_manager = $Head/Camera/Hand/WeaponManager

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_weapon_idx = 0
#	weapons_on[current_weapon_idx].visible = true
	body_normal_height = body.shape.height
	body_normal_radius = body.shape.radius
	

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		if _leaning:
			camera.rotation.y = clamp(head.rotation.y, deg2rad(-89), deg2rad(89))
			mouse_sensitivity = 0.05
	if event is InputEventMouseButton:
		var temp_index: int
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				temp_index += 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				temp_index -= 1
		if temp_index < 0:
			temp_index = 2
		elif temp_index > 2:
			temp_index = 0
		current_weapon_idx = temp_index
		weapon_manager.equip_weapon(current_weapon_idx)

func _process(delta):
#	if Engine.get_frames_per_second() > Engine.iterations_per_second:
#		camera.set_as_toplevel(true)
#		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(
#											head.global_transform.origin, cam_accel * delta)
#		camera.rotation.y = rotation.y
#		camera.rotation.x = head.rotation.x
#		body.translation.z = camera.translation.z
#		body.global_transform.origin = camera.global_transform.origin
#	else:
	camera.set_as_toplevel(true)
	camera.global_transform = head.global_transform
	body.translation.z = head.translation.z
	body.global_transform.origin = camera.global_transform.origin


func fire():
	if Input.is_action_pressed("fire"):
		weapon_manager.fire_weapon()
		camera.translation = lerp(camera.translation, 
			Vector3(rand_range(MAX_CAMERA_SHAKE, -MAX_CAMERA_SHAKE),
					rand_range(MAX_CAMERA_SHAKE, -MAX_CAMERA_SHAKE), 0), 0.5)
	else:
		camera.translation = CAMERA_NORMAL_POS
		anim_player.stop()

func lean() -> void:
	var original_body_pos = global_transform.origin
	var original_head_pos = head.global_transform.origin

	var axis = (Input.get_action_strength("lean_left") - Input.get_action_strength("lean_right"))

	var from = global_transform.origin + CAMERA_NORMAL_POS
	var to = CAMERA_NORMAL_POS + (head.global_transform.basis.x * 15 * -axis)
	head.global_transform.origin = lerp(from, to, 0.1)

	if axis != 0:
		_leaning = true
	else:
		_leaning = false
#		head.global_transform.origin = original_head_pos
#		global_transform.origin = original_body_pos
		camera.translation = original_head_pos

func crouch():
	var original_body_pos = global_transform.origin
	var original_head_pos = head.global_transform.origin
	
	

func change_weapon_with_keyboard() -> void:
	if Input.is_action_just_pressed("primary_weapon"):
		weapon_manager.get_primary()
	if Input.is_action_just_pressed("secondary_weapon"):
		weapon_manager.get_secondary()
	if Input.is_action_just_pressed("meelee_weapon"):
		weapon_manager.get_meelee()
	

func _physics_process(delta):
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()

#	fire()
#	change_weapon_with_keyboard()

	
	if direction != Vector3.ZERO:
		_walking = true
	else:
		_walking = false
	
	if _walking == false:
		lean()

	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * weight * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and _can_jump:
		snap = Vector3.ZERO
		gravity_vec += Vector3.UP * jump

	if Input.is_action_pressed("sprint"):
		if f_input < 0:
			accel = ACCEL_SPRINT
	
	if Input.is_action_just_pressed("crouch"):
		if !_crouching:
			anim_player.play("crouch_down")
			_crouching = true
			_stealth = true
		elif is_on_ceiling():
			_can_jump = false
		else:
			anim_player.play_backwards("crouch_down")
			_crouching = false
			_stealth = false
			_walking = true
	
	if Input.is_action_pressed("walk_slow"):
		_stealth = true

	if _stealth == true:
		accel = ACCEL_STEALTH

	if !_leaning or !_crouching:
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
		_walking = true
		move_and_slide_with_snap(movement, snap, Vector3.UP)


func _on_WeaponManager_firing():
	pass # Replace with function body.
