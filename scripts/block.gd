extends StaticBody2D
class_name Block

@onready var ray_cast = $RayCast2D as RayCast2D
@onready var bump_sound = $Bump as AudioStreamPlayer2D

func bump():
	bump_sound.play()
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "position", position + Vector2(0, -5), 0.12)
	bump_tween.chain().tween_property(self, "position", position, 0.12)
	check_for_enemy_collision()

func check_for_enemy_collision():
	if ray_cast.is_colliding() and ray_cast.get_collider() is Enemy:
		(ray_cast.get_collider() as Enemy).die_from_hit()
