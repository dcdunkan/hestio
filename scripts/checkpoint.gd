extends Node
class_name Checkpoint

var checked = false
@export var spawnpoint = false
@onready var flag_sprite = $AnimatedSprite2D
@onready var area_2d = $Area2D

func _process(delta):
	if not checked:
		flag_sprite.play("no-flag")

func check():
	checked = true
	flag_sprite.play("flag-out")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and not checked:
		print("setting checkpoint")
		LevelManager.current_checkpoint = self
		check()

# make sure the animation is switched to the idle one as soon as its finished
func _on_animated_sprite_2d_animation_finished():
	if flag_sprite.animation == "flag-out":
		flag_sprite.play("flagged")
