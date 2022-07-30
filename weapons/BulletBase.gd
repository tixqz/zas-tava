extends RigidBody
class_name Bullet

onready var timer = $Timer
onready var raycast = $RayCast
onready var bullet = $"."

export(float) var velocity = 100.0
export(float) var acceleration = 10.0
export(float) var lifetime = 3.0

var damage: int
var accuracy: float

func _init(damage, accuracy):
	self.damage = damage
	self.accuracy = accuracy

func _ready():
	set_as_toplevel(true)
	timer.start(lifetime)
	apply_central_impulse(-transform.basis.z * velocity)

func _physics_process(delta):
	pass

func _on_Timer_timeout():
	bullet.queue_free()
