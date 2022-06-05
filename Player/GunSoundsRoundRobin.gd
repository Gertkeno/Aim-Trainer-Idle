extends AudioStreamPlayer

class_name GunshotRoundRobin

export(Array, AudioStream) var body: Array
export(Array, AudioStream) var miss: Array
export(Array, AudioStream) var head: Array

func set_gunshot_hit(h: String) -> void:
	if h == "body":
		self.stream = body[randi() % body.size()]
	elif h == "miss":
		self.stream = miss[randi() % miss.size()]
	elif h == "head":
		self.stream = head[randi() % head.size()]
	else:
		push_error("Not a audio type" + h)
