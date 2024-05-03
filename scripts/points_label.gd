extends Label

func set_points(points: int):
	text = str(points)

func _ready():
	var label_tween = get_tree().create_tween()
	label_tween.tween_property(self, "position", position + Vector2(0, -10), 0.4)
	label_tween.tween_callback(queue_free)
	
