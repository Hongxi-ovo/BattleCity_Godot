extends Area2D
@export var custom_class_name = "Prop"
var value = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if value != -1:
		$Sprite2D.frame = value
	else:
		$Sprite2D.frame = randi_range(0,6)
	position = Vector2i(randi_range(3,27)*32,randi_range(2,26)*32)
	$AudioStreamPlayer.play()
	print(str($Sprite2D.frame))
func _on_timer_timeout() -> void:
	$Sprite2D.visible = !$Sprite2D.visible

func _on_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "tank":
		#print(str(area.get_parent().PlayerNum) + "吃到了道具")
		get_parent().eatProp(position,area.get_parent().PlayerNum,$Sprite2D.frame)
		queue_free()
