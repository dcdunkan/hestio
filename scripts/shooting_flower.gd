extends Area2D
class_name ShootingFlower

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -16), 0.4)
