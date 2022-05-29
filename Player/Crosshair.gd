extends Node2D

onready var crosshairs: Array = []
onready var sprite := $Sprite as Sprite
var parentDirectory := "res://assets/kenney_crosshairPack/PNG/White/"
var index := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	look_for_image_file(parentDirectory)

func look_for_image_file(path: String):
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if not file_name.ends_with(".import"):
					#print("Found file: " + file_name)
					crosshairs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occured when trying to access the path.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position = self.get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		if index < crosshairs.size() - 1:
			index += 1
		else:
			index = 0
	elif event.is_action_pressed("ui_down"):
		if index > 0:
			index -= 1
		else:
			index = crosshairs.size() - 1
	else:
		return

	var texture := load(parentDirectory + crosshairs[index])
	sprite.set_texture(texture)
