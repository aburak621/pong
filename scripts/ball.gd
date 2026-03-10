class_name Ball extends CharacterBody2D

signal collided()
signal scored(scored_player: int)

@export var speed: float = 200
@export var speed_per_bounce: float = 25

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var velo: Vector2 = Vector2.LEFT


func _ready() -> void:
	reset()


func _physics_process(delta: float) -> void:
	var motion := velo * delta
	var collision := move_and_collide(motion)

	if collision:
		if (collision.get_collider() as Node).name == "Player1Goal":
			scored.emit(2)
			return
		elif (collision.get_collider() as Node).name == "Player2Goal":
			scored.emit(1)
			return

		collided.emit()

		var object := (collision.get_collider() as Node2D)
		if (collision.get_collider() as Node).is_in_group("paddle"):
			var direction := Vector2(sign(velo.bounce(collision.get_normal()).x), 1)
			velo = (Vector2.RIGHT * (velo.length() + speed_per_bounce)).rotated(remap(clampf((collision.get_position().y - object.position.y) / (object as Paddle).paddle_scale, -1, 1), -1, 1, deg_to_rad(-45), deg_to_rad(45))) * direction
		else:
			velo = velo.bounce(collision.get_normal())


func reset() -> void:
	global_position = Vector2(960, 540)
	velo = Vector2.LEFT.rotated(deg_to_rad(randf_range(20, 55))) * speed * Vector2([-1, 1].pick_random(), [-1, 1].pick_random())
