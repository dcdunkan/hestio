extends Area2D
class_name Enemy

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")

@export var horizontal_speed = 20
@export var vertical_speed = 100
@onready var points_value: int
@export var is_idle: bool = false

@onready var left_ray_cast = $LeftRayCast2D as RayCast2D
@onready var right_ray_cast = $RightRayCast2D as RayCast2D
@onready var down_ray_cast = $DownRayCast2D as RayCast2D
@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D

var scale_factor = Vector2(0.07, 0.07)
var global_position_factor = Vector2(0.5, 0.0)
var is_idle_animation_playing = false
var is_inhaling = true

var ignore_left_collision = false
var ignore_right_collision = true

func _process(delta):
	if not down_ray_cast.is_colliding() and not is_idle_animation_playing:
		position.y += delta * vertical_speed
	if not is_idle:
		position.x -= delta * horizontal_speed
		# the looped left right collision movements
		if (left_ray_cast.is_colliding() and not ignore_left_collision) or (right_ray_cast.is_colliding() and not ignore_right_collision):
			horizontal_speed = -horizontal_speed
			ignore_left_collision = !ignore_left_collision
			ignore_right_collision = !ignore_right_collision
	elif down_ray_cast.is_colliding() and not is_idle_animation_playing:
		is_idle_animation_playing = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", scale + (scale_factor if is_inhaling else -scale_factor), 0.5)
		tween.tween_property(self, "global_position", global_position - (global_position_factor if is_inhaling else -global_position_factor), 0.5)
		tween.tween_callback(func ():
			is_idle_animation_playing = false
			is_inhaling = !is_inhaling
		)

func die():
	horizontal_speed = 0
	vertical_speed = 0
	sprite.play("death")
	
func die_from_hit():
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	rotation_degrees = 180
	vertical_speed = 0
	horizontal_speed = 0
	
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(0, -25), 0.2)
	die_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
	
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.set_points(points_value)
	points_label.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	
func _on_area_entered(area):
	if area is Koopa and (area as Koopa).in_a_shell and (area as Koopa).horizontal_speed != 0:
		die_from_hit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
