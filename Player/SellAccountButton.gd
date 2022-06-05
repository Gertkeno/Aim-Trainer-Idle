extends Button

var resetStatNames: Array = [
	"playerXP",
	"headshotMultiplier",
	"fireDelay",
	"targetWorth",
	"respawnTime",
	"totalPurchases",
	"headshotChance",
	"aimSpeed",
]
var resetStatValues: Array = []
var buttonStatBaseCosts: Array = []

export(int, 0, 100) var minimumPurchases = 8
export(int, 1, 50) var doshPerPurchases = 3

signal account_sold

func _ready() -> void:
	for name in resetStatNames:
		# Copy stats, better if we don't have to edit two places
		resetStatValues.append(Stats.get(name))
	Stats.connect("xpChanged", self, "_set_text")

	buttonStatBaseCosts.resize(resetStatNames.size())
	for button in get_tree().get_nodes_in_group("purchaseableButton"):
		var b := button as Purchaseable
		assert(b != null)
		var index: int = resetStatNames.find(b.statName)
		if index >= 0:
			buttonStatBaseCosts[index] = b.baseCost

func sell_account() -> void:
	var potentialWorth := get_account_worth()
	if potentialWorth > 0:
		Stats.playerDosh += potentialWorth

		for i in resetStatNames.size():
			Stats.set(resetStatNames[i], resetStatValues[i])

		var buttons := get_tree().get_nodes_in_group("purchaseableButton")
		for button in buttons:
			var b := button as Purchaseable
			assert(b != null)
			var index: int = resetStatNames.find(b.statName)
			if index >= 0:
				b.baseCost = buttonStatBaseCosts[index]
				b.update_text()
		emit_signal("account_sold", potentialWorth)
		_set_text()
		($AudioStreamPlayer as AudioStreamPlayer).play()

func get_account_worth() -> float:
	var output: float = max(0, (Stats.totalPurchases - minimumPurchases) / doshPerPurchases)
	return floor(output * output/3)

func _set_text() -> void:
	var worth := get_account_worth()
	self.text = "Sell Account: $" + str(floor(worth))
	self.disabled = worth == 0
