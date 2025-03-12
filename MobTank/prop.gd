extends Area2D
@export var custom_class_name = "Prop"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = randi_range(0,6)
	position = Vector2i(randi_range(3,27)*32,randi_range(2,26)*32)
	$AudioStreamPlayer.play()
func _on_timer_timeout() -> void:
	$Sprite2D.visible = !$Sprite2D.visible

func _on_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "tank":
		get_parent().eatProp(position,area.get_parent().PlayerNum,$Sprite2D.frame)
		queue_free()
