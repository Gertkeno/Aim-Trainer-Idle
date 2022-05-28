extends Spatial

class_name PlayerGun

onready var camera: Camera = $CameraPivot/Camera
var rayOrigin := Vector3()
var rayEnd := Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	var space_state := get_world().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 8
	var intersection := space_state.intersect_ray(rayOrigin, rayEnd, [], 2)

	var pos: Vector3

	if not intersection.empty():
		if Input.is_action_just_pressed("Click"):
			var enemy = intersection.collider
			print("Killed a mother fuckgerer!?", enemy.get_name())
			enemy.get_parent().free()
		pos = Vector3(intersection.position)
	else:
		pos = rayEnd

	($GunPivot as Spatial).look_at(pos, Vector3(0,1,0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		pass

var inViewport := false

func _on_ViewportContainer_mouse_entered() -> void:
	inViewport = true


func _on_ViewportContainer_mouse_exited() -> void:
	inViewport = false
