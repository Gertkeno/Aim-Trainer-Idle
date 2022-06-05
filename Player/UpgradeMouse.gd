extends Button


export(Array, Texture) var textures: Array
onready var textureR := $TextureRect as TextureRect
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button_pressed() -> void:
	
	if index < textures.size() - 1:
		index += 1
		textureR.texture = textures[index]
		Stats.
	else:
		index += 0
