extends Enemy
class_name Goomba

const POINTS = 200

func _ready():
	points_value = POINTS

func die():
	super.die()
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	get_tree().create_timer(0.75).timeout.connect(queue_free)
