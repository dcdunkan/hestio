extends StaticBody2D
class_name Cannon

@export var player: Player

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

var should_shoot = false

func bump():
	pass

func _on_spawn_timer_timeout():
	if should_shoot:
		var bullet = BULLET_SCENE.instantiate()
		bullet.direction = sign(player.position.x - global_position.x)
		bullet.scale.x = sign(global_position.x - player.position.x)
		bullet.global_position = Vector2(global_position.x, global_position.y - 5)
		bullet.z_index = z_index - 1
		get_tree().root.add_child(bullet)

func _on_visible_on_screen_enabler_2d_screen_entered():
	should_shoot = true
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	should_shoot = true
