extends Block
class_name MysteryBox

enum BonusType {
	Coin,
	Mushroom,
	Flower
}

const COIN_SCENE = preload("res://scenes/coin.tscn")
const SHROOM_SCENE = preload("res://scenes/shroom.tscn")
const SHOOTING_FLOWER_SCENE = preload("res://scenes/shooting_flower.tscn")

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D

@export var bonus_type: BonusType = BonusType.Coin
@export var invisible = false
@export var empty = false

func _ready():
	sprite.visible = !invisible

func bump():
	if empty:
		return
	
	if invisible:
		sprite.visible = true
		invisible = false
	
	super.bump()
	
	match bonus_type:
		BonusType.Coin:
			spawn_coin()
		BonusType.Mushroom:
			spawn_mushroom()
		BonusType.Flower:
			spawn_flower()
	
	empty_box()

func empty_box():
	empty = true
	sprite.play("empty")

func spawn_coin():
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position + Vector2(0, -16)
	get_tree().root.add_child(coin)
	var manager = get_tree().get_first_node_in_group("level_manager") as LevelManager
	manager.on_coin_collected()
	
func spawn_mushroom():
	var shroom = SHROOM_SCENE.instantiate()
	shroom.global_position = global_position
	get_tree().root.add_child(shroom)
	
func spawn_flower():
	var flower = SHOOTING_FLOWER_SCENE.instantiate()
	flower.global_position = global_position
	get_tree().root.add_child(flower)
