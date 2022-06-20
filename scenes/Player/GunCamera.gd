extends Camera

export(NodePath) var camera_path

var camera: Camera

func _ready():
	camera = get_node(camera_path)
	var env = camera.get_environment()
	set_environment(env)

func _process(delta):
	global_transform = camera.global_transform

