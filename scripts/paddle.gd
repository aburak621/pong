class_name Paddle extends CharacterBody2D

signal ball_hit()

@export var player_no: int = 1
@export var speed: float = 1000
@export var paddle_scale: int = 32

@onready var up_action: String = "player_" + str(player_no) + "_up"
@onready var down_action: String = "player_" + str(player_no) + "_down"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var height: float


func _ready() -> void:
	height = paddle_scale * 2
	(collision_shape.shape as RectangleShape2D).size.y = height
	sprite.scale.y = paddle_scale


func _physics_process(delta: float) -> void:
	var input := Input.get_axis(up_action, down_action)

	if input != 0:
		position.y = clampf(global_position.y + input * speed * delta, height / 2, 1080 - height / 2)
