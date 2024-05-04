extends CharacterBody2D
class_name Player

@export var max_lives = 3
var lives = 3

var can_fireball = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")
const FIREBALL_SCENE = preload("res://scenes/fireball.tscn")

@onready var shooting_point = $ShootingPoint
@onready var area_2d = $Area2D
@onready var sprite = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_collision_shape = $Area2D/AreaCollisionShape2D as CollisionShape2D
@onready var body_collision_shape = $BodyCollisionShape2D

# audios
@onready var jump_short_sound = $"../Sounds/JumpShort"
@onready var jump_long_sound = $"../Sounds/JumpLong"
@onready var stomp_sound = $"../Sounds/Stomp"
@onready var die_sound = $"../Sounds/Die"
@onready var _1_up_eats_sound = $"../Sounds/1UpEats"


@export_group("Motion")
@export var run_speed_damping = 0.5
@export var speed = 200.0
@export var jump_velocity = -350
@export_group("")

@export_group("Enemy Collision")
@export var min_stomp_angle = 35
@export var max_stomp_angle = 145
@export var stomp_y_velocity = -150
@export_group("")

@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export var should_bound_left: bool = true
@export_group("")

var should_accept_input = true

func _ready():
	LevelManager.player = self
	camera_sync.global_position.x = global_position.x
	camera_sync.global_position.y = global_position.y - (camera_sync.get_viewport_rect().size.y / 2 / camera_sync.zoom.y) + 50

func _physics_process(delta):
	var camera_left_bound = camera_sync.global_position.x - camera_sync.get_viewport_rect().size.x / 2 / camera_sync.zoom.x
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if sign(velocity.y) == 1 and global_position.y > 250:
		die(false)
	
	if should_bound_left and global_position.x < camera_left_bound + 8 && sign(velocity.x) == -1:
		velocity = Vector2.ZERO
		return
	
	if should_accept_input and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump_short_sound.play()
	
	if should_accept_input and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		jump_short_sound.stop()
		jump_long_sound.play(0.1)
		
	
	var direction = Input.get_axis("left", "right")
	if direction and should_accept_input:
		velocity.x = lerpf(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	if should_accept_input and Input.is_action_just_pressed("shoot"):
		shoot()
	else:
		sprite.trigger_animation(velocity, direction)
	
	var collision = get_last_slide_collision()
	if collision != null:
		handle_movement_collision(collision)
	
	move_and_slide()

func _process(_delta):
	var camera_left_bound = camera_sync.global_position.x - camera_sync.get_viewport_rect().size.x / 2 / camera_sync.zoom.x
	if global_position.x < camera_left_bound and not should_bound_left and should_camera_sync:
		camera_sync.global_position.x = global_position.x
	
	if global_position.x > camera_sync.global_position.x and should_camera_sync:
		camera_sync.global_position.x = global_position.x
	var viewport_y_half = camera_sync.get_viewport_rect().size.y / 2 / camera_sync.zoom.y
	var upper_limit = 50
	var lower_limit = 60
	
	if global_position.y > 200:
		should_camera_sync = false
		die(false)
		return
		
	# towards bottom
	if global_position.y > camera_sync.global_position.y + viewport_y_half - lower_limit and should_camera_sync:
		camera_sync.global_position.y = global_position.y - viewport_y_half + lower_limit
	# towards top
	if global_position.y < camera_sync.global_position.y - viewport_y_half + upper_limit  and should_camera_sync:
		camera_sync.global_position.y = global_position.y + viewport_y_half - upper_limit

func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)
	if area is Shroom:
		handle_shroom_collision(area)
		area.queue_free()
	if area is ShootingFlower:
		handle_flower_collision()
		area.queue_free()
	if area is Hammer:
		die(true)

func handle_enemy_collision(enemy: Enemy):
	if enemy == null and lives == 0:
		return
		
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
		spawn_points_label(enemy)
	elif is_instance_of(enemy, Piranha):
		die(true)
	else:
		var collision_angle = rad_to_deg(position.angle_to_point(enemy.position))
		if collision_angle >= min_stomp_angle and collision_angle <= max_stomp_angle:
			enemy.die()
			on_enemy_stomped()
			spawn_points_label(enemy)
		else:
			die(true)

func handle_shroom_collision(_area: Shroom):
	_1_up_eats_sound.play()
	if lives != max_lives:
		lives = lives + 1

func handle_flower_collision():
	if not can_fireball:
		can_fireball = true

func spawn_points_label(enemy: Enemy):
	if not enemy is Bullet:
		var points_label = POINTS_LABEL_SCENE.instantiate()
		points_label.set_points(enemy.points_value)
		points_label.position = enemy.position + Vector2(-20, -20)
		get_tree().root.add_child(points_label)
		#LevelManager.on_points_scored(enemy.points_value)
		var manager = get_tree().get_first_node_in_group("level_manager") as LevelManager
		manager.on_points_scored(enemy.points_value)

func on_enemy_stomped():
	stomp_sound.play()
	velocity.y = stomp_y_velocity
	
func die(show_animation: bool):
	area_2d.set_collision_mask_value(3, false)
	set_collision_layer_value(1, false)
	die_sound.play()
	lives = lives - 1
	sprite.play("death")
	should_camera_sync = false
	set_physics_process(false)
	
	if show_animation:
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), 0.5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		await death_tween.finished
	
	#await get_tree().create_timer(5.0).timeout
	reset_player()
	should_camera_sync = true
	

func reset_player():
	if LevelManager.current_checkpoint != null:
		LevelManager.respawn_player()
		print("respawning at checkpoint")
	else:
		print("no checkpoints: should respawn at the beginning or say game over")
		get_tree().reload_current_scene()
	
	area_2d.set_collision_mask_value(3, true)
	set_collision_layer_value(1, true)
	set_physics_process(true)
	camera_sync.global_position.x = global_position.x
	camera_sync.global_position.y = global_position.y - (camera_sync.get_viewport_rect().size.y / 2 / camera_sync.zoom.y) + 50

func handle_movement_collision(collision: KinematicCollision2D):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump()

func shoot():
	sprite.play("shoot")
	set_physics_process(false)
	
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.direction = sign(sprite.scale.x)
	fireball.global_position = shooting_point.global_position
	get_tree().root.add_child(fireball)
