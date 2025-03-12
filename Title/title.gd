extends Node2D
var GamePlayerNum: int
# 默认赋值给I和Hi的值
var I: String = "00"
var Hi: String = "20000"
# 默认选择的选项 应该对应 1PLAYER
var Selects: int = 0
# 信号
signal TitleStop

# 判断当前标题是否在移动 true为默认在移动的
var titleMove: bool = true
# 在循环之前执行的内容
func _ready() -> void:
	# 先隐藏坦克的贴图 等到加载完成以后再显示出来
	$Sprite2D.visible = false
	# 将Node2D节点的内容移动到如图所示位置
	$Node2D.position = Vector2(0, 896)
	# 设置分数
	$"Node2D/Title-I-Num".text = I
	$"Node2D/Title-HI-Num2".text = Hi


# 循环运行的内容
func _process(delta: float) -> void:
	if titleMove == true:
		TitleMoveing(delta)
		return
	if titleMove == false:
		TitleMoved()
		return
# 标题移动
func TitleMoveing(delta):
	$Node2D.position.y -= 200 * delta
	if $Node2D.position.y <= 0 or Input.is_action_just_pressed("start1"):
		$Node2D.position.y = 0
		titleMove = false
		$Sprite2D.visible = true
		$AnimationPlayer.play("move")
# 根据标题当前是否已经移动到位置 如果没有则立马到位 否则直接操作
func TitleMoved():
	if Input.is_action_just_pressed("select1") and $Node2D.position.y <= 0:
		Selects += 1
		if Selects > 2:
			Selects = 0
		$Sprite2D.position.y = 528 + (Selects * 64)
	if Input.is_action_just_pressed("start1") and $Node2D.position.y <= 0:
		Menus(Selects)
		# 一个逐渐过渡到黑暗的动画
		$BlackAniamtion.play("blacking")
		
# 根据Value的值 来执行下面的内容
func Menus(Value):
	# 获取父节点
	var parent_GamePlayerNum = get_parent()
	# 将0传入父节点的GamePlayerNum
	if Value == 0:
		if parent_GamePlayerNum:
			parent_GamePlayerNum.GamePlayerNum = 0
	# 将1传入父节点的GamePlayerNum
	if Value == 1:
		if parent_GamePlayerNum:
			parent_GamePlayerNum.GamePlayerNum = 1
	# 将2传入父节点的GamePlayerNum
	if Value == 2:
		if parent_GamePlayerNum:
			parent_GamePlayerNum.GamePlayerNum = 2

# 当过渡到黑暗的动画结束后，发出TitleStop信号
func _on_black_aniamtion_animation_finished(_anim_name: StringName) -> void:
	emit_signal("TitleStop")
	await TitleStop
