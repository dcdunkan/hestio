extends Enemy
class_name Koopa

const POINTS = 100

var in_a_shell = false

const KOOPA_SHELL_COLLISION_SHAPE_POSITION = Vector2(0, 5)
const KOOPA_FULL_COLLISION_SHAPE = preload("res://resource/koopa_full_collision_shape.tres")
const KOOPA_SHELL_COLLISION_SHAPE = preload("res://resource/koopa_shell_collision_shape.tres")

@onready var collision_shape = $CollisionShape2D as CollisionShape2D

@export var slide_speed = 200

func _ready():
	points_value = POINTS
	collision_shape.shape = KOOPA_FULL_COLLISION_SHAPE

func die():
	if not in_a_shell:
		super.die()
	
	collision_shape.set_deferred("shape", KOOPA_SHELL_COLLISION_SHAPE)
	collision_shape.set_deferred("position", KOOPA_SHELL_COLLISION_SHAPE_POSITION)
	in_a_shell = true
	
func on_stomp(player_position: Vector2):
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)
	
	var movement_direction = 1 if player_position.x <= global_position.x else -1
	horizontal_speed = -movement_direction * slide_speed

