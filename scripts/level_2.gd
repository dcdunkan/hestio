extends Node

@onready var camera = $Camera2D
@onready var level_switch_area = $LevelSwitchArea

# start the animation
func _on_animation_start_entrance_area_body_entered(body):
	var zoom_out_animation = get_tree().create_tween()
	zoom_out_animation.tween_property(camera, "zoom", camera.zoom - Vector2(1, 1), 3)

func _on_walk_animation_start_area_body_entered(body):
	if body is Player:
		var animated_sprite = body.get_children()[0] as AnimatedSprite2D
		body.set_physics_process(false)
		animated_sprite.play("run")
		var walk_tween = get_tree().create_tween()
		walk_tween.tween_property(body, "position", Vector2(level_switch_area.global_position.x, body.position.y), 2.4)
		walk_tween.chain().tween_property(body, "position", Vector2(level_switch_area.global_position.x, body.position.y - 5), 0.4)
		walk_tween.chain().tween_property(body, "scale", Vector2(0, 0), 4)
		walk_tween.tween_callback(func ():
			body.visible = false
			LevelManager.goto_next_level()
		)
