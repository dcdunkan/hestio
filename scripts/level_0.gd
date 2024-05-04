extends Node2D

@onready var logofinal = $Logofinal
@onready var camera_2d = $Camera2D
@onready var start_instruction = $"Logofinal/Start Instruction"

var can_be_started = false

func _ready():
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
	
func _process(delta):
	if can_be_started and Input.is_action_just_pressed("start"):
		LevelManager.goto_next_level()
