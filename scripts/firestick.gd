extends Area2D
class_name Firestick

@export var rotation_speed = 120
@export var direction = 1

func _process(delta):
	rotation_degrees = rotation_degrees + (direction * rotation_speed * delta)
	
func _on_body_entered(body):
	if body is Player:
		(body as Player).die(true)
