class_name ScoreLabel extends Label


func update_score(value: int = 1) -> void:
	text = str(text.to_int() + value)
