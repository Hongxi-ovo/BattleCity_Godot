extends Node2D

var Change: bool = false
var isSelect:bool = false
var SelectNums: int = 0
var SelectLevel: int = 1
signal ChangeSuccess

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("moveDown")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("a1") and SelectLevel < 35 and $Stage.visible == true and isSelect == true:
		SelectLevel += 1
	if Input.is_action_just_pressed("b1") and SelectLevel > 1 and $Stage.visible == true  and isSelect == true:
		SelectLevel -= 1
	if Input.is_action_just_pressed("start1") and $AudioStreamPlayer.playing == false and $Stage.visible == true  and isSelect == true:
		get_parent().SelectLevel = SelectLevel
		get_parent().changeSceneSignal()
		$AudioStreamPlayer.play()
		$Timer.start()
		isSelect = false
	$StageNum.text = str(SelectLevel)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (SelectNums == 0 or SelectNums == 1) and anim_name == "moveDown":
		$Stage.visible = true
		$StageNum.visible = true
		return
	if (SelectNums == 0 or SelectNums == 1) and anim_name == "moveUp":
		get_parent().changeSceneSignal()
		return
	if anim_name == "moveDown":
		get_parent().changeSceneSignal()
		$AnimationPlayer.play("moveUp")
	if anim_name == "moveUp":
		queue_free()

func _on_timer_timeout() -> void:
	$Stage.visible = false
	$StageNum.visible = false
	$AnimationPlayer.play("moveUp")
	get_parent().SelectLevel = SelectLevel
	
func changeStage(scene):
	$StageNum.text = str(get_parent().SelectLevel)
	$AnimationPlayer.play("moveDown")
	
	$Timer2.start()
	get_parent().GameScene()
	scene.queue_free()

func _on_timer_2_timeout() -> void:
	$AudioStreamPlayer.play()
	$Timer.start()
	isSelect = false
	
