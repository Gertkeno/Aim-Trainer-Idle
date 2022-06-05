extends CPUParticles

class_name Explosion

func _ready() -> void:
	self.emitting = true

func _on_Timer_timeout() -> void:
	self.queue_free()
