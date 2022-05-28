extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0


func _ready():
	label.set_text(str(amount))
	
	tween.interpolate_property(self,'scale',scale,Vector2(1,1),.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.interpolate_property(self,'scale',Vector2(1,1),Vector2(.1,.1),.7,Tween.TRANS_LINEAR,Tween.EASE_OUT,.3)
	self.position = self.get_global_mouse_position()
	tween.start()


func _on_Tween_tween_all_completed():
	self.queue_free()
