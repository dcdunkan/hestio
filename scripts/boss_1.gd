extends CharacterBody2D
class_name AIML_Boss

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast_2d = $RayCast2D

@export var camera: Camera2D

var effective_gravity = 490
var jet_acceleration = gravity * 0.4
var is_jet_accelerated = false

func _physics_process(delta):
	var max_height = camera.global_position.y # - (camera.get_viewport_rect().size.y / camera.zoom.y)
	
	if not is_jet_accelerated:
		position.y += effective_gravity * delta
	else:
		velocity.y -= jet_acceleration * delta
	
	if ray_cast_2d.is_colliding():
		is_jet_accelerated = true
	elif position.y < max_height:
		is_jet_accelerated = false
		
	move_and_slide()
