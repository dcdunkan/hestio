extends Node

const PATH_PREFIX = "res://levels/level_%d.tscn"
@export var TOTAL_LEVELS = 6 # 6

@export var current_level = 1
var current_checkpoint: Checkpoint
var player: Player

func on_coin_collected():
	print("coin collected")
	
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func goto_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_level = current_scene_file.split("_")[1].to_int()
	if current_level == TOTAL_LEVELS:
		print("last level bro, this should not be happening")
	else:
		var next_level_path = PATH_PREFIX % (current_level + 1)
		get_tree().change_scene_to_file(next_level_path)
		
func timeout(time: float):
	await get_tree().create_timer(time).timeout
