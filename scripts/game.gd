class_name Game extends Node

var ball: Ball


func _ready() -> void:
	ball = get_tree().get_first_node_in_group("ball")
	ball.scored.connect(player_scored)


func player_scored(player: int) -> void:
	match player:
		1:
			$Control/ScoreLabel1.update_score()
		2:
			$Control/ScoreLabel2.update_score()
	reset_game()


func reset_game() -> void:
	$Level/Paddle1.position = Vector2(108, 540)
	$Level/Paddle2.position = Vector2(1812, 540)
	ball.reset()
