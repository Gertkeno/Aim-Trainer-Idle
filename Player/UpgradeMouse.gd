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
			_update_all_buttons()
	else:
		index += 0

func _update_all_buttons() -> void:
	for i in get_tree().get_nodes_in_group("purchaseableButton"):
		var b := i as Purchaseable
		assert(b != null)
		b.update_text()
