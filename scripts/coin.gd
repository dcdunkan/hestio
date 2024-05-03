extends AnimatedSprite2D

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -40), 0.3)
	tween.chain().tween_property(self, "position", position, 0.3)
	tween.tween_callback(queue_free)
