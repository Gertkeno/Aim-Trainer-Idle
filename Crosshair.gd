extends Node2D

onready var crosshairs = []
onready var sprite := $Sprite as Sprite
var parentDirectory = "res://assets/kenney_crosshairPack/PNG/White/"
var index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	look_for_image_file(parentDirectory)

func look_for_image_file(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
				#print("Found directory: " + file_name)
			else:
				if !file_name.ends_with(".import"):
					#print("Found file: " + file_name)
					crosshairs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occured when trying to access the path.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position = self.get_global_mouse_position()
	if(Input.is_action_just_pressed("ui_up")):
		index += 1
		var image = Image.new()
		var texture = ImageTexture.new()
		image.load(parentDirectory + crosshairs[index])
		texture.create_from_image(image)
		sprite.set_texture(texture)

