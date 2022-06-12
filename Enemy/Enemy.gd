extends Spatial

class_name Enemy

export(PackedScene) var explosion: PackedScene = preload("res://Enemy/explosion.tscn")
var floating_text := preload("res://Enemy/FloatingText.tscn")

onready var head := $Head as KinematicBody
onready var body := $Body as KinematicBody

# Called when the node enters the scene tree for the first time.
func _ready():
	head.collision_layer = 0x4 # layer 3 NOT shootable
	body.collision_layer = 0x4
	self.visible = false
	#set_dead(0)

func respawn():
	head.collision_layer = 0x2 # Layer 2 to be shootable
	body.collision_layer = 0x2
	self.visible = true

func set_dead(value: float):
	head.collision_layer = 0x4 # layer 3 NOT shootable
	body.collision_layer = 0x4
	var text := floating_text.instance() as FloatingText
	text.amount = value

	add_child(text)
	self.visible = false
	Stats.playerXP += value

	var explode := explosion.instance() as Explosion
	explode.translate(self.global_transform.origin)
	get_tree().get_root().add_child(explode)
