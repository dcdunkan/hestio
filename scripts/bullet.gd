extends Enemy
class_name Bullet

@onready var ray_cast_2d = $RayCast2D

var direction: int

func _process(delta):
	position.x += delta * horizontal_speed * direction
	
# collides with the player
func _on_body_entered(body):
	if not body is Cannon:
		queue_free()
		
	if body is Player:
		(body as Player).die(true)
	elif body is Koopa or body is Goomba:
		(body as Koopa).die_from_hit()

func die():
	horizontal_speed = 0
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
