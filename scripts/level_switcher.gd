extends Node2D
class_name LevelSwitcher

@onready var sprite = $Sprite2D

func _on_area_2d_area_entered(area: Area2D):
	if area.get_parent() is Player:
		await get_tree().create_timer(5.0).timeout
		LevelManager.goto_next_level()

func _on_area_2d_2_body_entered(body):
	if body is Player:
		var animated_sprite = body.get_children()[0] as AnimatedSprite2D
		body.set_physics_process(false)
		animated_sprite.stop()
		sprite.play("open")
		animated_sprite.play("run")
		while body.position.x < global_position.x:
			body.position.x += 1
			await get_tree().create_timer(0.025).timeout
		body.visible = false
		await get_tree().create_timer(1.0).timeout
		sprite.play_backwards("open")
