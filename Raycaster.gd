extends Spatial

class_name PlayerGun

export (float, 5, 200) var rayLength := 50
onready var camera := $CameraPivot/Camera as Camera
var rayEnd := Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _hit_enemy(hitbox: KinematicBody) -> void:
	if hitbox == null:
		return

	var enemy := hitbox.get_parent() as Enemy
	if enemy == null or not enemy.visible:
		return

	var value: int
	if hitbox.get_name() == "Head":
		print("Headshot")
		value = 2
	else:
		print("Bodyshot")
		value = 1

	enemy.set_dead(value)

func _physics_process(_delta: float) -> void:
	var space_state := get_world().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var rayOrigin := camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * rayLength
	var intersection := space_state.intersect_ray(rayOrigin, rayEnd, [], 2)

	if not intersection.empty():
		if Input.is_action_just_pressed("Click"):
			_hit_enemy(intersection.collider)

	($GunPivot as Spatial).look_at(rayEnd, Vector3(0,1,0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		pass

