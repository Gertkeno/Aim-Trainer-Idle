tool
extends Button

export var statName: String
export var displayName: String
export var bonusValue: float
export var cost: float

onready var timer := $Timer as Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	Stats.connect("xpChanged", self, "_set_purchasable")

func _set_purchasable() -> void:
	self.disabled = not(Stats.playerDosh >= self.cost and timer.is_stopped())

func update_text() -> void:
	($Label as Label).text = displayName + "\n$" + str(round(cost))

func update_all_buttons() -> void:
	for i in get_tree().get_nodes_in_group("purchaseableButton"):
		var b := i as Purchaseable
		assert(b != null)
		b.update_text()

func _on_Button_pressed():
	if Stats.playerDosh >= cost and timer.is_stopped():
		Stats.playerDosh -= cost
		Stats.set(statName, Stats.get(statName) + bonusValue)
		update_all_buttons()
		timer.start()
		_set_purchasable()

func _on_Timer_timeout() -> void:
	Stats.set(statName, Stats.get(statName) - bonusValue)
	update_all_buttons()
	_set_purchasable()
