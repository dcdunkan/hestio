extends Area2D
class_name Deathblock

func _on_body_entered(body):
	if body is Player:
		body.die(true)
