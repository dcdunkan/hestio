extends AnimatedSprite2D
class_name PlayerAnimatedSprite

func trigger_animation(velocity: Vector2, direction: int):
	if not get_parent().is_on_floor():
		play("jump")
	elif sign(velocity.x) != sign(direction) and velocity.x != 0 and direction != 0:
		play("slide")
		scale.x = direction
	else:
		if scale.x == 1 and velocity.x < 0:
			scale.x = -1
		elif scale.x == -1 && velocity.x > 0:
			scale.x = 1
		
		# run and idle animations
		if velocity.x != 0:
			play("run")
		else:
			play("idle")
			
			
func _on_animation_finished():
	match animation:
		"shoot":
			get_parent().set_physics_process(true)
