extends Area2D
var custom_class_name = "map"
@export var Expansion: PackedScene
var bigExpansion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bigExpansion = Expansion.instantiate()
	bigExpansion.Type = 1


func _on_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "Bullet" and $Sprite2D.frame == 0:
		add_child(bigExpansion)
		$AudioExpansion.play()
		$Sprite2D.frame = 1
