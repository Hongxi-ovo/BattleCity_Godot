extends Area2D
var custom_class_name = "iron"

var ironPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buildXY()


func buildXY():
	if ironPosition == 0:
		position -= Vector2(16, 16)
	if ironPosition == 1:
		position += Vector2(16, -16)
	if ironPosition == 2:
		position += Vector2(-16, 16)
	if ironPosition == 3:
		position += Vector2(16, 16)


func _on_area_entered(area: Area2D) -> void:
	# print(area.name)
	if (area.custom_class_name == "TerrainBullet"):
		get_parent().AudioSelect(area.get_parent().BulletType)
		if area.get_parent().BulletType > 2:
			queue_free()
