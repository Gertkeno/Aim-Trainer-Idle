extends Node

var currentLoc = Vector3()
var locations = []
var enemies = []
var locationAmt = 247 # Amount of enemies needed
var rowAmt = 22 # Back row holds 22 enemies
var enemyStartAmt = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	
	currentLoc.y = 0.05
	var zIncrement = 0
	var xIncrement = 0

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
		var scene = load("res://Enemy/Enemy.tscn")
		var enemy = scene.instance()
		enemy.set_translation(get_random_location())
		add_child(enemy)
		enemy.respawn()
		enemies.append(enemy)
		
func get_random_location():
	randomize()
	return locations[randi() % locations.size()]
	
func show_random_enemies(num: int):
	
	randomize()
	
	for _i in range(0,num):
		var enemy = enemies[randi() % enemies.size()]
		enemy.set_translation(get_random_location())
		enemy.rotation_degrees.y = randi() % 360
		enemy.respawn()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Spacebar"):
		show_random_enemies(1)
