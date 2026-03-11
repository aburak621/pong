class_name Game extends Node

@export var paddle_hit_sound: AudioStream
@export var wall_hit_sound: AudioStream
@export var score_sound: AudioStream

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var audio_playback: AudioStreamPlaybackPolyphonic
var ball: Ball


func _ready() -> void:
	audio_player.play()
	audio_playback = audio_player.get_stream_playback()

	ball = get_tree().get_first_node_in_group("ball")
	ball.scored.connect(player_scored)
	ball.collided.connect(play_sound)


func player_scored(player: int) -> void:
	match player:
		1:
			$Control/ScoreLabel1.update_score()
		2:
			$Control/ScoreLabel2.update_score()
	audio_playback.play_stream(score_sound)
	reset_game()


func reset_game() -> void:
	$Level/Paddle1.position = Vector2(108, 540)
	$Level/Paddle2.position = Vector2(1812, 540)
	ball.reset()


func play_sound(paddle_hit: bool) -> void:
	if paddle_hit:
		audio_playback.play_stream(paddle_hit_sound)
	else:
		audio_playback.play_stream(wall_hit_sound)
