extends Node



export var statName: String
export var displayName: String
export var bonusValue: String
export var cost: float 


# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	
func update_text() -> void:
	($Label as Label).text = displayName + "\n"+ "$" + str(round(cost)) + "\n[" + str(Stats.get(statName)) + "]"

func _on_Button_pressed():
	
	if Stats.playerDosh < cost:
		return
	else:
		Stats.playerDosh -= cost
		Stats.set(statName, Stats.get(statName) + bonusValue)
