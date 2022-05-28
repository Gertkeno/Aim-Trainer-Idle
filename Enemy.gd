extends MeshInstance

class_name Enemy

onready var head := $Head as KinematicBody
onready var body := $Body as KinematicBody

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func respawn():
	head.collision_layer = 2 # Layer 2 to be shootable
	body.collision_layer = 2
	self.visible = true
	
func set_dead():
	head.collision_layer = 3 # layer 3 NOT shootable
	body.collision_layer = 3
	self.visible = false
