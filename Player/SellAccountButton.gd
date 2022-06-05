extends Button

var resetStatNames: Array = [
	"playerXP",
	"headshotMultiplier",
	"fireDelay",
	"targetWorth",
	"respawnTime",
	"totalPurchases",
]

var resetStatValues: Array = []

signal account_sold

func _ready() -> void:
	for name in resetStatNames:
		# Copy stats, better if we don't have to edit two places
		resetStatValues.append(Stats.get(name))
	Stats.connect("xpChanged", self, "_set_text")

func sell_account() -> void:
	var potentialWorth := get_account_worth()
	if potentialWorth > 0:
		Stats.playerDosh += potentialWorth

		for i in resetStatNames.size():
			Stats.set(resetStatNames[i], resetStatValues[i])
		emit_signal("account_sold", potentialWorth)


func get_account_worth() -> float:
	return max(0, (Stats.totalPurchases - 1) / 10)

func _set_text() -> void:
	var worth := get_account_worth()
	self.text = "Sell Account: $" + str(floor(worth))
	self.disabled = worth == 0
