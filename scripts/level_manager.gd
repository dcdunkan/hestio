extends Node

const PATH_PREFIX = "res://levels/level_%d.tscn"
@export var TOTAL_LEVELS = 6

@export var hud: HUD
var current_checkpoint: Checkpoint
@export var player: Player

var points = 0
var coins = 0
var current_level = 0

func on_coin_collected():
	coins += 1
	Data.set_coins(coins)
	hud.set_coins(coins)

func on_points_scored(points_scored: int):
	points += points_scored
	Data.set_points(points)
	hud.set_score(points)
	
func set_lives(lives: int):
	Data.set_lives(lives)
	
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func goto_level(level: int):
	var level_path = PATH_PREFIX % (level)
	get_tree().change_scene_to_file(level_path)

func goto_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_level_no = current_scene_file.split("_")[1].to_int()
	if current_level_no == TOTAL_LEVELS:
		current_level = 0
		print("last level bro, this should not be happening")
	else:
		var next_level_path = PATH_PREFIX % (current_level_no + 1)
		get_tree().change_scene_to_file(next_level_path)
		
func timeout(time: float):
	await get_tree().create_timer(time).timeout
