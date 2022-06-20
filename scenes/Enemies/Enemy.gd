extends KinematicBody

const MOVE_SPEED = 10.0
const RUN_SPEED = 15.0

var health

enum Behaviour {
	PATROL,
	DEAD,
}

func _ready():
	health = 100

func move(delta):
	pass

func die(delta):
	pass

func look_at_player():
	pass

func _physics_process(delta):
	pass

