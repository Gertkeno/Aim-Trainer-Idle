extends Button


signal mouse_upgraded

export(Array, Texture) var textures: Array
onready var textureR := $TextureRect as TextureRect
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button_pressed() -> void:
	
	if index < textures.size() - 1:
		index += 1
		emit_signal("mouse_upgraded")
		textureR.texture = textures[index]
	else:
		index += 0
