extends Camera

export(OpenSimplexNoise) var noise

#maximum camera angles
export(float) var max_X = 10.0
export(float) var max_Y = 10.0
export(float) var max_Z = 5.0

var trauma: float = 0.0
var initial_rotation: Vector3 = rotation_degrees

func _process(delta):
	pass

