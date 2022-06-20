extends KinematicBody

export(NodePath) var weapon_manager_path

const MOUSE_SENSITIVITY: float = 0.1
const MOVE_SPEED: float = 10.0
const SPRINT_SPEED: float = 20.0
const CROUCH_SPEED: float = 3.0
const CROUCH_RATE: float = 0.6
const GRAVITY: float = 9.8
const JUMP_FORCE: float = 5.0

var acceleration

var playerState
var playerHeight
var currentWeaponIdx

var lockMovement = false

onready var head = $Head
onready var body = $Body
onready var camera = $Head/Camera
onready var gun_camera = $UI/ViewportContainer/Viewport/GunCamera

onready var move_impulse_vec = Vector3.UP
onready var gravity_vec = Vector3.ZERO
onready var snap = Vector3.ZERO
onready var velocity = Vector3.ZERO

onready var weaponManager = get_node(weapon_manager_path)

enum {
	WALK,
	JUMP,
	CROUCH,
	SPRINTING
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	playerHeight = body.shape.height
	acceleration = MOVE_SPEED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1 * event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
		event.relative

#func state_machine(delta):
#	pass

func set_state(state: int):
	playerState = state
	match state:
		WALK:
			acceleration = MOVE_SPEED
		CROUCH:
			acceleration = CROUCH_SPEED
		SPRINTING:
			acceleration = SPRINT_SPEED
		JUMP:
			pass

func get_input_direction():
	if not lockMovement:
		var move_direction_z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		var move_direction_x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
		var res_dir = Vector3(move_direction_x, 0, move_direction_z).normalized()
		var res_vec = global_transform.basis.xform(res_dir)
		return res_vec
	return Vector3.ZERO

func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_state(JUMP)
		gravity_vec = Vector3.UP * JUMP_FORCE
		snap = Vector3.ZERO

func crouch(delta):
	var _normal_height = playerHeight
	var _current_height = _normal_height
	if Input.is_action_just_pressed("crouch"):
		if playerState != CROUCH:
			body.shape.height = lerp(_normal_height, 1.5, 50 * delta)
			head.translation.y = lerp(_normal_height, 1.5, 50 * delta)
			_current_height = body.shape.height
			set_state(CROUCH)
		else:
			if not is_on_ceiling():
				body.shape.height = lerp(_current_height, _normal_height, 50 * delta)
				head.translation.y = lerp(_current_height, _normal_height, 50 * delta)
				set_state(WALK)

func sprint(delta):
	if Input.is_action_pressed("sprint"):
		set_state(SPRINTING)
		

func walk(delta):
	var input = get_input_direction()
	var direction = input * acceleration
	velocity = direction + gravity_vec

func _physics_process(delta):
	snap = Vector3.DOWN
	
	if is_on_floor():
		snap = -get_floor_normal()
		gravity_vec = Vector3.ZERO
		lockMovement = false
	else:
		gravity_vec += GRAVITY * 1.3 * Vector3.DOWN * delta
		lockMovement = true

	walk(delta)
	jump(delta)
	crouch(delta)
	sprint(delta)
	
	move_and_slide_with_snap(velocity, snap, Vector3.UP)

