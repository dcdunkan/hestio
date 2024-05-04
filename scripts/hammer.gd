extends Area2D
class_name Hammer

var spawn_point: Vector2
var target_point: Vector2

var speed_factor

func _ready():
	speed_factor = randf_range(0.5, 0.8)

func _process(delta):
	position += delta * speed_factor * Vector2(spawn_point.x - target_point.x, spawn_point.y - target_point.y)

func _on_body_entered(body):
	if body is Player:
		(body as Player).die(true)
		queue_free()

func _on_area_entered(_area):
	queue_free()
