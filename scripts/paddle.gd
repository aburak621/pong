class_name Paddle extends CharacterBody2D

signal ball_hit

@export var player_no: int = 1
@export var speed: float = 1000
@export var paddle_scale: int = 32

@onready var up_action: String = "player_" + str(player_no) + "_up"
@onready var down_action: String = "player_" + str(player_no) + "_down"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var ball: Ball = get_tree().get_first_node_in_group("ball")

var height: float
var is_cpu: bool = false
var cpu_difficulty: int = 1
var cpu_target_y: float
var random_rest_range: float = 300
var cpu_cooldown: float


func _ready() -> void:
	height = paddle_scale * 2
	(collision_shape.shape as RectangleShape2D).size.y = height
	sprite.scale.y = paddle_scale


func _physics_process(delta: float) -> void:
	var input: float
	if is_cpu:
		var ball_approaching: bool = ball.velo.x > 0 and ball.position.x > 1360

		if not ball_approaching:
			cpu_cooldown -= delta
			
			if cpu_cooldown < 0:
				cpu_cooldown += randf_range(0.4, 0.8)
				cpu_target_y = randf_range(540 - random_rest_range, 540 + random_rest_range)
		else:
			var time_until_hit := (1820 - ball.position.x) / ball.velo.x

			if time_until_hit < 0:
				cpu_target_y = position.y
			else:
				var time_until_wall_hit := (
					(ball.position.y - 8) / -ball.velo.y
					if ball.velo.y < 0
					else (1072 - ball.position.y) / ball.velo.y
				)

				if time_until_hit - time_until_wall_hit > 0:
					cpu_target_y = (
						8 + abs(ball.velo.y) * (time_until_hit - time_until_wall_hit)
						if ball.velo.y < 0
						else 1072 - abs(ball.velo.y) * (time_until_hit - time_until_wall_hit)
					)
				else:
					cpu_target_y = ball.position.y + time_until_hit * ball.velo.y

		var y_delta := cpu_target_y - position.y
		input = sign(0.0 if abs(y_delta) < 16 else y_delta)
	else:
		input = Input.get_axis(up_action, down_action)

	if input != 0:
		position.y = clampf(
			global_position.y + input * speed * delta, height / 2, 1080 - height / 2
		)
