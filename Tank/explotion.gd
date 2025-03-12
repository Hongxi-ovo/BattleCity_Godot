extends Node2D

@export var Type:int = 0

signal animation_finished_and_freed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation(Type)

func play_animation(explotionType:int = 0 ):
	if explotionType == 0:
		$AnimationPlayer.play("Explosion_small")

	else:
		$AnimationPlayer.play("Expansion_big")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	emit_signal("animation_finished_and_freed")
	queue_free()
