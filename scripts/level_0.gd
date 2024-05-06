extends Node2D

@onready var logofinal = $Logofinal
@onready var camera_2d = $Camera2D
@onready var start_instruction = $"Logofinal/Start Instruction"
@onready var startmusic = $startmusic

var can_be_started = false

func _ready():
	startmusic.play()
	var tween = get_tree().create_tween()
	tween.tween_property(logofinal, "position", camera_2d.global_position, 5)
	tween.chain().tween_property(start_instruction, "visible", true, 0.5)
	tween.tween_callback(func ():
		can_be_started = true
	)
	tween.chain().tween_property(start_instruction, "visible", false, 0.5)
	tween.chain().tween_property(start_instruction, "visible", true, 0.5)
	tween.chain().tween_property(start_instruction, "visible", false, 0.5)
	tween.chain().tween_property(start_instruction, "visible", true, 0.5)
	tween.chain().tween_property(start_instruction, "visible", false, 0.5)
	tween.chain().tween_property(start_instruction, "visible", true, 0.5)
	
func _process(_delta):
	if can_be_started and Input.is_action_just_pressed("start"):
		LevelManager.goto_next_level()
		
