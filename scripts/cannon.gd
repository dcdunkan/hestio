extends StaticBody2D
class_name Cannon

@export var player: Player

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

func bump():
	pass

func _on_spawn_timer_timeout():
	var bullet = BULLET_SCENE.instantiate()
	bullet.direction = sign(player.position.x - global_position.x)
	bullet.scale.x = sign(global_position.x - player.position.x)
	bullet.global_position = Vector2(global_position.x, global_position.y - 5)
	bullet.z_index = z_index - 1
	get_tree().root.add_child(bullet)
