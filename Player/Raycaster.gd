extends Spatial

class_name PlayerGun

export (float, 5, 200) var rayLength := 50
onready var camera := $CameraPivot/Camera as Camera
var shootCooldown: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _hit_enemy(hitbox: KinematicBody) -> bool:
	if hitbox == null:
		return false

	var enemy := hitbox.get_parent() as Enemy
	if enemy == null or not enemy.visible:
		return false

	var value: float = Stats.targetWorth
	if hitbox.get_name() == "Head":
		print("Headshot")
		value *= Stats.headshotMultiplier

	enemy.set_dead(value)
	return true

func _process(delta: float) -> void:
	var space_state := get_world().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var rayOrigin := camera.project_ray_origin(mouse_position)
	var rayEnd := rayOrigin + camera.project_ray_normal(mouse_position) * rayLength
	var intersection := space_state.intersect_ray(rayOrigin, rayEnd, [], 2)

	shootCooldown += delta
	if not intersection.empty():
		if Input.is_action_pressed("Fire") and shootCooldown > Stats.get_fire_delay():
			if _hit_enemy(intersection.collider):
				# do Juicy Fx
				pass
			shootCooldown = 0

	($GunPivot as Spatial).look_at(rayEnd, Vector3(0,1,0))
