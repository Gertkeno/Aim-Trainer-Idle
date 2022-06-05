tool
extends Button

class_name Purchaseable

export var statName: String
export var displayName: String
export (int, "XP", "Dosh") var costType: int = 0
export var baseCost: float = 1
export (int, "linear", "exponential") var costScalingType: int = 1
export var costScalingRate: float = 1.7
export var bonusValue: float = 1

onready var streamer := $AudioStreamPlayer as AudioStreamPlayer

signal purchased(statName)

func _ready() -> void:
	update_text()
	Stats.connect("xpChanged", self, "_set_purchasable")

func _set_purchasable() -> void:
	if costType == 0:
		self.disabled = Stats.playerXP < self.baseCost
	else:
		self.disabled = Stats.playerDosh < self.baseCost

func update_text() -> void:
	var postfix: String = "XP" if costType == 0 else "$"
	($Label as Label).text = displayName + "\n" + str(round(baseCost*Stats.discountValue)) + postfix + "\n[" + str(Stats.get(statName)) + "]"

func _on_Button_pressed() -> void:
	if costType == 0:
		if Stats.playerXP < baseCost*Stats.discountValue:
			return
		else:
			Stats.playerXP -= baseCost*Stats.discountValue
	elif costType == 1:
		if Stats.playerDosh < baseCost:
			return
		else:
			Stats.playerDosh -= baseCost

	emit_signal("purchased", statName)

	if not streamer.playing:
		streamer.play()
	Stats.set(statName, Stats.get(statName) + bonusValue)
	Stats.totalPurchases += 1

	if costScalingType == 0:
		self.baseCost += costScalingRate
	elif costScalingType == 1:
		self.baseCost = max(self.baseCost + 1, self.baseCost * costScalingRate)

	_set_purchasable()
	update_text()
