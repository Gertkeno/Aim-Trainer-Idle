tool
extends Button

class_name Purchaseable

enum CostScaling {linear, exponential}

export var statName: String
export var displayName: String
export var baseCost: float = 1
export (int, "linear", "exponential") var costScalingType: int = 1
export var costScalingRate: float = 1.7
export var bonusValue: float = 1
export var bonusScaler: float = 1

signal purchased(statName)

func _ready() -> void:
	update_text()
	Stats.connect("doshChanged", self, "_is_purchasable")

func _is_purchasable() -> void:
	self.disabled = Stats.playerDosh < self.baseCost

func update_text() -> void:
	($Label as Label).text = displayName + "\n" + str(round(baseCost)) + "XP\n[" + str(Stats.get(statName)) + "]"

func _on_Button_pressed() -> void:
	if Stats.playerDosh < baseCost:
		# epic fail
		return
	Stats.playerDosh -= baseCost

	emit_signal("purchased", statName)

	Stats.set(statName, Stats.get(statName)*bonusScaler + bonusValue)
	if costScalingType == 0:
		baseCost += costScalingRate
	elif costScalingType == 1:
		baseCost *= costScalingRate

	update_text()
