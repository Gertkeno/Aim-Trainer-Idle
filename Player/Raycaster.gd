extends Spatial

export (float, 5, 200) var rayLength := 50
export (int, LAYERS_3D_PHYSICS) var rayhit: int = 2
onready var camera := $CameraPivot/Camera as Camera
onready var gun := $GunPivot/AK as Spatial
onready var gunAnimation := $GunPivot/AnimationPlayer as AnimationPlayer
onready var tween := $Aimbot as Tween
onready var gunPivot := $GunPivot as Spatial
onready var ray := $GunPivot/AK/RayCast as RayCast
onready var mashingTimer := $Aimbot/MashingFire as Timer
onready var gunshotSound := $AudioStreamPlayer as GunshotRoundRobin
var shootCooldown: float = 1 / Stats.fireDelay

func get_fire_delay() -> float:
	return 1 / Stats.fireDelay

func _get_parent_enemy(node: Node) -> Enemy:
	if node == null:
		return null
	elif node is Enemy:
		return node as Enemy
	else:
		return _get_parent_enemy(node.get_parent())

func _hit_enemy(hitbox: KinematicBody) -> bool:
	if hitbox == null:
		return false

	var enemy := _get_parent_enemy(hitbox)
	if enemy == null or not enemy.visible:
		return false

	var value: float = Stats.targetWorth
	if hitbox.get_name() == "Head":
		value *= Stats.headshotMultiplier
		gunshotSound.set_gunshot_hit("head")
	else:
		gunshotSound.set_gunshot_hit("body")

	enemy.set_dead(value)
	return true

func fire_fx() -> void:
	($GunPivot/Sprite3D as Sprite3D).frame = randi() % 15 + 1
	gunAnimation.stop()
	gunAnimation.play("Fire")

# get a random visible enemy or null
func _find_random_enemy() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var valids := []
	for enemy in enemies:
		if enemy.visible:
			valids.append(enemy)

	if valids.size() > 0:
		return valids[randi() % valids.size()];
	else:
		return null

# Start the aimbotting process, pick a random target and tween to it always
# takes 3/aimSpeed seconds. Firing wildly at the target
var lastAimbotTarget: Enemy
func _start_aimbot() -> void:
	lastAimbotTarget = _find_random_enemy()
	tween.remove_all()
	if lastAimbotTarget == null:
		($Aimbot/Retry as Timer).start()
		return

	var randheight: float = randf() * 1.4 + 0.2
	var lookpoint: Vector3 = lastAimbotTarget.global_transform.origin + Vector3.UP * randheight
	var final := gunPivot.global_transform.looking_at(lookpoint, Vector3.UP)
	tween.interpolate_property(
		gunPivot,
		'global_transform',
		gunPivot.global_transform,
		final,
		3 / Stats.aimSpeed,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()

var aimbotting := false
func _process(delta: float) -> void:
	# Toggle aimbot with tab
	if Input.is_action_just_pressed("HotkeyAimbot"):
		if aimbotting:
			aimbotting = false
			ray.enabled = false
			tween.remove_all()
		else:
			aimbotting = true
			ray.enabled = true
			_start_aimbot()
			mashingTimer.wait_time = get_fire_delay()
			mashingTimer.start()

	if aimbotting:
		return

	# manual aiming, can't use raycast object here
	var space_state := get_world().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var rayOrigin := camera.project_ray_origin(mouse_position)
	var rayEnd := rayOrigin + camera.project_ray_normal(mouse_position) * rayLength
	var intersection := space_state.intersect_ray(rayOrigin, rayEnd, [], rayhit)

	shootCooldown += delta
	if Input.is_action_pressed("Fire") and shootCooldown > get_fire_delay():
		if not intersection.empty():
			_hit_enemy(intersection.collider)
		else:
			gunshotSound.set_gunshot_hit("miss")
		shootCooldown = 0
		fire_fx()

	gunPivot.look_at(rayEnd, Vector3.UP)

# Aimbot has reached target destination, check if they have died yet
func _on_Aimbot_tween_all_completed() -> void:
	if aimbotting:
		if lastAimbotTarget.visible == false:
			_start_aimbot()
		else:
			# target is not dead, restart the aimbot in a second
			($Aimbot/Retry as Timer).start()

func _on_Retry_timeout() -> void:
	if aimbotting:
		_start_aimbot()

# Using $RayCast object collision detection
func _get_gun_hit() -> Enemy:
	var hit := ray.get_collider() as KinematicBody
	if hit != null:
		return hit.get_parent() as Enemy
	else:
		return null

# This repeating timer should run inline with aimbotting matchingfire rate, if
# the ray hit anything on fire we kill it with a random headshot
func _on_MashingFire_timeout() -> void:
	if aimbotting:
		mashingTimer.wait_time = get_fire_delay()
		var hit := _get_gun_hit()
		if hit != null:
			var worth := Stats.targetWorth
			if randi() % 100 <= Stats.headshotChance:
				worth *= Stats.headshotMultiplier
				gunshotSound.set_gunshot_hit("head")
			else:
				gunshotSound.set_gunshot_hit("body")
			hit.set_dead(worth)
			_start_aimbot()
		else:
			gunshotSound.set_gunshot_hit("miss")
		fire_fx()
	else:
		mashingTimer.stop()

func _on_Autofire_toggled(button_pressed: bool) -> void:
	if button_pressed and not aimbotting:
		aimbotting = true
		ray.enabled = true
		_start_aimbot()
		mashingTimer.wait_time = get_fire_delay()
		mashingTimer.start()
	elif not button_pressed and aimbotting:
		aimbotting = false
		ray.enabled = false
		tween.remove_all()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
