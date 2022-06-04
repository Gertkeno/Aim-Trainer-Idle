extends Node2D

onready var sprite := $Sprite as Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position = self.get_global_mouse_position()

func _input(event: InputEvent) -> void:
	var highFrame := sprite.hframes * sprite.vframes - 1
	if event.is_action_pressed("ui_up"):
		if sprite.frame >= highFrame:
			sprite.set_frame(0)
		else:
			sprite.frame += 1
	elif event.is_action_pressed("ui_down"):
		if sprite.frame > 0:
			sprite.frame -= 1
		else:
			sprite.set_frame(highFrame)


func _on_Button2_purchased(statName):
	if statName == "targetWorth":
		var highFrame := sprite.hframes * sprite.vframes - 1
		if sprite.frame >= highFrame:
			sprite.set_frame(0)
		else:
			sprite.frame += 1
