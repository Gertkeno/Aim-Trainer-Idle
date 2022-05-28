extends Spatial

class_name Enemy

var floating_text := preload("res://FloatingText.tscn")

onready var head := $Head as KinematicBody
onready var body := $Body as KinematicBody

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func respawn():
	head.collision_layer = 2 # Layer 2 to be shootable
	body.collision_layer = 2
	self.visible = true

func set_dead(value: int):
	head.collision_layer = 3 # layer 3 NOT shootable
	body.collision_layer = 3
	var text := floating_text.instance() as FloatingText
	text.amount = value
	add_child(text)
	self.visible = false

func _process(_delta):
	if(Input.is_action_just_pressed("Spacebar")):
		respawn()
