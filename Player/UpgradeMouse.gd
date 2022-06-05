extends Button


export(Array, Texture) var textures: Array
onready var textureR := $TextureRect as TextureRect
var index = 0
var cost = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button_pressed() -> void:
	
	if index < textures.size() - 1:
		if Stats.playerDosh < cost:
			return
		else:
			index += 1
			textureR.texture = textures[index]
			Stats.playerDosh -= cost
			Stats.discountValue *= 0.8
			cost *= 10
	else:
		index += 0
