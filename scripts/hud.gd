extends CanvasLayer
class_name HUD

@onready var overlay_screen = $MarginContainer/OverlayScreen
@onready var overlay_screen_label = $MarginContainer/OverlayScreen/Panel/OverlayScreenLabel

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var coin_label = $MarginContainer/HBoxContainer/CoinLabel

func set_score(points: int):
	score_label.text = "SCORE: %010d" % points

func set_coins(coins: int):
	coin_label.text = "COINS: %03d" % coins

func show_overlay_screen(text: String):
	overlay_screen.visible = true
	overlay_screen_label.text = text
