extends Node2D
var score:int = 100
func _ready() -> void:
	$RichTextLabel.text = str(score)

func _on_timer_timeout() -> void:
	queue_free()
