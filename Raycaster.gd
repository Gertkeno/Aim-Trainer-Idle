extends Spatial


onready var camera = $CameraPivot/Camera
var rayOrigin = Vector3()
var rayEnd = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	
	var space_state = get_world().direct_space_state
	
	var mouse_position = get_viewport().get_mouse_position()
	
	rayOrigin = camera.project_ray_origin(mouse_position)
	
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd)
	
	var pos
	
	if not intersection.empty():
		pos = intersection.position
	else:
		pos = rayEnd
	
	($GunPivot as Spatial).look_at(Vector3(pos.x,pos.y,pos.z),Vector3(0,1,0))
	
