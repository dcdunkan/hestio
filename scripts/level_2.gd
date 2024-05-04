extends Node

@onready var camera = $Camera2D
@onready var level_switch_area = $LevelSwitchArea
@onready var stop_point = $StopWalkingPoint as Marker2D

func _ready():
	LevelManager.current_level = 2

# start the animation
func _on_animation_start_entrance_area_body_entered(player):
	if player is Player:
		player.should_accept_input = false
		var player_sprite = player.get_children()[0] as AnimatedSprite2D
		while !player.is_on_floor(): pass
		player_sprite.play("run")
		player.set_physics_process(false)
		
		var zoom_out_animation = get_tree().create_tween().set_parallel()
		zoom_out_animation.tween_property(camera, "zoom", camera.zoom - Vector2(1, 1), 2.7)
		zoom_out_animation.tween_property(player, "position", Vector2(stop_point.position.x, player.position.y), 2.7)
		zoom_out_animation.chain().tween_callback(func ():
			player_sprite.play("idle")
		)
		await zoom_out_animation.finished
		
		await get_tree().create_timer(4.0).timeout
		
		player_sprite.play("run")
		
		var walk_tween = get_tree().create_tween().set_parallel()
		walk_tween.tween_property(camera, "zoom", camera.zoom + Vector2(1, 1), 4)
		walk_tween.tween_property(player, "position", Vector2(level_switch_area.global_position.x, player.position.y), 4)
		walk_tween.chain().tween_property(player, "position", Vector2(level_switch_area.global_position.x, player.position.y - 5), 0.4)
		walk_tween.chain().tween_property(player, "scale", Vector2(0, 0), 4)
		await walk_tween.finished
		
		player.visible = false
		LevelManager.goto_next_level()
