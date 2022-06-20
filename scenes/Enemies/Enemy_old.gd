extends KinematicBody
class_name Enemy

export(NodePath) var patrolPath

onready var animPlayer = $AnimationPlayer
onready var head = $head/head
onready var patrol = get_node(patrolPath)

const CALM_VELOCITY = 10.0
const DISTURBED_VELOCITY = 20.0

var enemy_type = ""
var health = 100
var armor = 0.1
var velocity = CALM_VELOCITY

onready var State: int = EnemyState.IDLE


enum EnemyState {
	IDLE,
	ATTACK,
	HIT,
	SUSPECT,
	MOVING,
	PATROL,
	DEAD,
}

func _ready():
	set_state(EnemyState.IDLE)

func _process(delta):
	pass

func _physics_process(delta):
	if health <= 0:
		set_state(EnemyState.DEAD)
	got_hit()

func got_hit():
	pass

func get_gun():
	pass

func look_at_player(target):
	if target.is_in_group("Player"):
		set_state(EnemyState.SUSPECT)
		head.look_at(target.global_transform.origin, Vector3.UP)

func set_state(state):
	State = state
	match state:
		EnemyState.DEAD:
			animPlayer.play("death")
		EnemyState.ATTACK:
			pass
		EnemyState.HIT:
			pass
		EnemyState.SUSPECT:
			pass
		EnemyState.MOVING:
			pass
		EnemyState.PATROL:
			pass
		EnemyState.IDLE:
			pass
		
