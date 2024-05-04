extends Enemy
class_name HammerThrower

const POINTS = 400
	
@export var player: Player
@onready var hammer_holding_point = $HammerHoldingPoint

const HAMMER_SCENE = preload("res://scenes/hammer.tscn")

@export var MIN_HAMMERS = 1
@export var MAX_HAMMERS = 4

var hammers = 0
var can_throw = false

func reload_hammer_count():
	hammers = randi_range(MIN_HAMMERS, MAX_HAMMERS)

func _ready():
	points_value = POINTS
	reload_hammer_count()

func _on_reload_timer_timeout():
	print("reloading")
	reload_hammer_count()

func _on_throw_timer_timeout():
	print("trying to throw")
	if hammers == 0 or not can_throw:
		return
		
	print("thrown")

	hammers -= 1
	var hammer = HAMMER_SCENE.instantiate()
	hammer.global_position = hammer_holding_point.global_position
	hammer.spawn_point = -1 * hammer_holding_point.global_position
	hammer.target_point = -1 * player.global_position
	hammer.target_point.x = randf_range(hammer.target_point.x - 30, hammer.target_point.x + 30)
	hammer.target_point.y = randf_range(hammer.target_point.y - 30, hammer.target_point.y + 30)
	get_tree().root.add_child(hammer)

func die():
	super.die()
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	get_tree().create_timer(0.75).timeout.connect(queue_free)

func _on_visible_on_screen_enabler_2d_screen_entered():
	can_throw = true

func _on_visible_on_screen_enabler_2d_screen_exited():
	can_throw = false
