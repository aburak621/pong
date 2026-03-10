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

	while collision:
		if (collision.get_collider() as Node).name == "Player1Goal":
			scored.emit(2)
			return
		elif (collision.get_collider() as Node).name == "Player2Goal":
			scored.emit(1)
			return


		collided.emit()
		velo = velo.bounce(collision.get_normal()).normalized() * (velo.length() + speed_per_bounce)

		motion = collision.get_remainder().bounce(collision.get_normal())
		collision = move_and_collide(motion)


func reset() -> void:
	global_position = Vector2(960, 540)
	velo = Vector2.LEFT.rotated(deg_to_rad(randf_range(20, 55))) * speed * Vector2([-1, 1].pick_random(), [-1, 1].pick_random())
