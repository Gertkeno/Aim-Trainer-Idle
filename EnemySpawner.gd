extends Node

var currentLoc = Vector3()
var locations = []
var enemies = []
var locationAmt = 247 # Amount of enemies needed
var rowAmt = 22 # Back row holds 22 enemies

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

	for i in locations:
		var scene = load("res://Enemy/Enemy_Animated.tscn")
		var enemy = scene.instance()
		enemy.set_translation(i)
		add_child(enemy)
		enemies.append(enemy)
		
	show_random_enemies(8) # How many enemies spawn at start of game
	
func show_random_enemies(num: int):
	
	randomize()
	
	for _i in range(0,num):
		enemies[randi() % enemies.size()].respawn()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Spacebar"):
		show_random_enemies(1)
