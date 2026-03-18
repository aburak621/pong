class_name Game extends Node

@export var paddle_hit_sound: AudioStream
@export var wall_hit_sound: AudioStream
@export var score_sound: AudioStream

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var level: Node2D = $Level
@onready var main_menu: Control = $MainMenu

var audio_playback: AudioStreamPlaybackPolyphonic
var ball: Ball


func _ready() -> void:
	Engine.max_fps = DisplayServer.screen_get_refresh_rate() as int
	stop_game()

	audio_player.play()
	audio_playback = audio_player.get_stream_playback()

	ball = get_tree().get_first_node_in_group("ball")
	ball.scored.connect(player_scored)
	ball.collided.connect(play_sound)


func player_scored(player: int) -> void:
	match player:
		1:
			%ScoreLabel1.update_score()
		2:
			%ScoreLabel2.update_score()
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if main_menu.visible:
			if OS.has_feature("editor"):
				get_tree().quit()
		else:
			stop_game()


func start_game(with_cpu: bool) -> void:
	main_menu.hide_menu()
	level.visible = true
	level.process_mode = Node.PROCESS_MODE_INHERIT

	$Level/Paddle2.is_cpu = with_cpu
	%ScoreLabel1.reset_score()
	%ScoreLabel2.reset_score()
	reset_game()


func stop_game() -> void:
	main_menu.show_menu()
	level.visible = false
	level.process_mode = Node.PROCESS_MODE_DISABLED
