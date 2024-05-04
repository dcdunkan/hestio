extends Node

@onready var boss_theme = $BossTheme as AudioStreamPlayer2D
@onready var default_bgm = $Sounds/BGM

func _ready():
	LevelManager.current_level = 6
	default_bgm.stop()
	boss_theme.play()
