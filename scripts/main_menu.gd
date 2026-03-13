class_name MainMenu extends Control

@onready var one_player_button: Button = $VBoxContainer/OnePlayer
@onready var two_player_button: Button = $VBoxContainer/TwoPlayer
@onready var quit_button: Button = $VBoxContainer/Quit
@onready var game: Game = get_parent()


func _ready() -> void:
	one_player_button.pressed.connect(game.start_game.bind(true))
	two_player_button.pressed.connect(game.start_game.bind(false))
	quit_button.pressed.connect(func() -> void: get_tree().quit())


func show_menu() -> void:
	visible = true
	one_player_button.grab_focus()


func hide_menu() -> void:
	visible = false
	one_player_button.grab_focus()
