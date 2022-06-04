extends Node

var currentLoc := Vector3()
var locations: Array = []
var enemies := []
var locationAmt := 247 # Amount of enemies needed
var rowAmt := 22 # Back row holds 22 enemies
var enemyStartAmt := 7

export(PackedScene) var enemyType: PackedScene

onready var timer := $RespawnTimer as Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLoc.y = 0.05
	var zIncrement: float = 0.0
	var xIncrement: float = 0.0

	while locationAmt > 0:
		for _i in range(0,rowAmt):
			currentLoc.x = -9.7 + xIncrement
			currentLoc.z = 9.7 + zIncrement
			locations.append(currentLoc)
			zIncrement -= .881818
			locationAmt -= 1
		rowAmt -= 1
		zIncrement += .881818*rowAmt
		zIncrement += .881818/2
		xIncrement += .64

	for _i in range(0,enemyStartAmt):
		var enemy := enemyType.instance() as Enemy
		enemy.set_translation(get_random_location())
		add_child(enemy)
		enemies.append(enemy)

	timer.start(Stats.respawnTime)

func get_random_location():
	randomize()
	return locations[randi() % locations.size()]

func show_random_enemies(num: int):

	randomize()

	for _i in range(0,num):
		var enemy := enemies[randi() % enemies.size()] as Enemy
		enemy.set_translation(get_random_location())
		enemy.rotation_degrees.y = randi() % 360
		enemy.respawn()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Spacebar"):
		show_random_enemies(1)
	#if event.is_action_released("Fire"):
	#	for i in enemies:
	#		if !i.is_visible_in_tree() && timer.is_stopped():
	#			timer.start(Stats.respawnTime)

func _on_RespawnTimer_timeout():
	for i in enemies:
		if !i.is_visible_in_tree():
			randomize()
			i.set_translation(get_random_location())
			i.rotation_degrees.y = randi() % 360
			i.respawn()
			break
	timer.wait_time = Stats.respawnTime
