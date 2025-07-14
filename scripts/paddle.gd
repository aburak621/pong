class_name Paddle extends AnimatableBody2D

signal ball_hit()

@export var player_no: int = 1
@export var speed: float = 1000

@onready var up_action: String = "player_" + str(player_no) + "_up"
@onready var down_action: String = "player_" + str(player_no) + "_down"

var height: float


func _ready() -> void:
	height = $Sprite2D.scale.y * 2


func _physics_process(delta: float) -> void:
	var input := Input.get_axis(up_action, down_action)

	if input != 0:
		global_position.y = clampf(global_position.y + input * speed * delta, height / 2, 1080 - height / 2)
