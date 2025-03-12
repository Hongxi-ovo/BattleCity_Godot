extends Node2D
#var BornPosition: Vector2 = Vector2.ZERO
signal animation_finished_and_freed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position = BornPosition
	$AnimationPlayer.play("Born")	


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	emit_signal("animation_finished_and_freed")
	queue_free()
