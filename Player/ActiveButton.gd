tool
extends Button

class_name ActiveButton

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

func _set_fill() -> void:
	var t := timer.time_left / timer.wait_time
	($Panel as Panel).anchor_right = t

func _process(_delta: float) -> void:
	if not Engine.editor_hint:
		_set_fill()

func _update_all_buttons() -> void:
	for i in get_tree().get_nodes_in_group("purchaseableButton"):
		var b := i as Purchaseable
		assert(b != null)
		b.update_text()

func _on_Button_pressed():
	if Stats.playerDosh >= cost and timer.is_stopped():
		Stats.playerDosh -= cost
		for stat in statName.split(','):
			Stats.set(stat, Stats.get(stat) + bonusValue)
		_update_all_buttons()
		timer.start()
		_set_purchasable()
		($AudioStreamPlayer as AudioStreamPlayer).play()

func _on_Timer_timeout() -> void:
	for stat in statName.split(','):
		Stats.set(stat, Stats.get(stat) - bonusValue)
	_update_all_buttons()
	_set_purchasable()

func force_reset():
	timer.stop()
	#timer.time_left = 0
