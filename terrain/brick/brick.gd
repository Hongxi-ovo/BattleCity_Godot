extends Area2D
var custom_class_name = "brick"
var brickPosition: int = 1
var NumbrickPosition: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NumPosition(NumbrickPosition)
	buildXY()
	$Sprite2D.frame = brickPosition

func NumPosition(num):
	if num == 0:
		position -= Vector2(16, 16)
		return
	if num == 1:
		position += Vector2(16, -16)
		return
	if num == 2:
		position += Vector2(-16, 16)
		return
	if num == 3:
		position += Vector2(16, 16)
		return

func buildXY():
	if brickPosition == 3:
		position += Vector2(8, 8)
		$StaticBody2D.position -= Vector2(8, 8)
		return
	if brickPosition == 2:
		position += Vector2(-8, 8)
		$StaticBody2D.position += Vector2(8, -8)
		return
	if brickPosition == 1:
		position += Vector2(8, -8)
		$StaticBody2D.position += Vector2(-8, 8)
		return
	if brickPosition == 0:
		position -= Vector2(8, 8)
		$StaticBody2D.position += Vector2(8, 8)
		return

func _on_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "Bullet":
		get_parent().AudioBrickhit()
		if area.BulletType > 2:
			get_parent().freeMain(NumbrickPosition)
		else:
			queue_free()
	elif area.custom_class_name == "MobBullet":
		if area.BulletType > 2:
			get_parent().freeMain(NumbrickPosition)
		else:
			queue_free()
		
func allDelete():
	queue_free()
