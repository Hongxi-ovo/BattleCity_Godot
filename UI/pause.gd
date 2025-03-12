extends Node2D

var isPlaying = false

func _on_timer_pause_timeout() -> void:
	$PAUSE.visible = !$PAUSE.visible

func audioPlay():
	isPlaying = true
	$AudioPause.play()

func _on_audio_pause_finished() -> void:
	isPlaying = false

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("start1") or Input.is_action_just_pressed("start2") )  and isPlaying == false:
		$Timer.start()


func _on_timer_timeout() -> void:
	$PAUSE.visible = false
	get_parent().get_parent().get_tree().paused = false
