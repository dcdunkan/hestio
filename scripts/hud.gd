extends CanvasLayer
class_name HUD

@onready var overlay_screen = $MarginContainer/OverlayScreen
@onready var overlay_screen_label = $MarginContainer/OverlayScreen/Panel/OverlayScreenLabel

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var coin_label = $MarginContainer/HBoxContainer/CoinLabel
@onready var lives_label = $MarginContainer/HBoxContainer/LivesLabel

func _ready():
	coin_label.text = "COINS: %03d" % Data.xcoins
	score_label.text = "SCORE: %05d" % Data.xpoints
	lives_label.text = "LIVES: %02d" % Data.xlives

func _process(delta):
	lives_label.text = "LIVES: %02d" % Data.xlives

func set_coins(coins: int):
	coin_label.text = "COINS: %03d" % coins

func set_score(points: int):
	score_label.text = "SCORE: %05d" % points
	
func set_lives(lives: int):
	lives_label.text = "LIVES: %02d" % lives

func show_overlay_screen(text: String):
	overlay_screen.visible = true
	overlay_screen_label.text = text

