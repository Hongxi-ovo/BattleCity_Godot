extends Node2D
var score:int = 1
func _ready() -> void:
	$Sprite2D.frame = score
	
func _on_timer_timeout() -> void:
	queue_free()
