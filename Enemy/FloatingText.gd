extends Position2D

class_name FloatingText

onready var label := $Node2D/Label as Label
onready var animation := $AnimationPlayer as AnimationPlayer
var amount: float = 0

func _ready():
	label.set_text(str(amount))
	animation.play("popout")
	self.position = self.get_global_mouse_position()

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	self.queue_free()
