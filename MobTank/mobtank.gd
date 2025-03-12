extends CharacterBody2D

@export var speed = 160
@export var exploration: PackedScene
var parent
# 当前的坦克编号
@export var TankNum: int = 0
@export var max_bullets: int = 1
# 通过定义坦克的颜色 然后通过动画属性来动态的调整颜色
# 0--白色
# 1--黄色
# 2--绿色
# 3--黄绿合色
# 坦克类型
# 0--坦克0
# 1--坦克1 特点 速度快
# 2--坦克2 
# 3--坦克3 特点 速度慢 装甲厚
@export var TankColor: int = 0
@export var TankLevelNum: int = 0
@export var isRedTank: int = 0

var isRed: bool = false
var isYellow: bool = false
var isGreen: bool = false


# 定义坦克的移动
# 0--上
# 1--左
# 2--下
# 3--右
# 4--下
var move:int = 4

func _ready() -> void:
	parent = get_parent()
	# if parent:
	# 	print("正常获取到了父节点，父节点为" + parent.name)
	# else:
	# 	print("未获取到父节点")
	# 初始化敌方坦克
	TankInitColor(TankColor)
	TankInitLevel(TankLevelNum)
	$AnimationPlayer.play("down")
	if isRedTank > 0:
		RedTank()
	timeset()

func TankInitColor(color: int = 0):
	if color == 0:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
		return
	if color == 1:
		YGColor()
		return
	if color == 2:
		YellowTank()
		return
	if color == 3:
		GreenTank()
		return
# 初始化坦克类型
func TankInitLevel(level: int = 0):
	if level == 0:
		return
	if level == 1:
		speed = 240
		return
	if level == 2:
		return
	if level == 3:
		$Sprite2D.region_rect = Rect2(0, TankLevelNum * 16 + 128, 128, 16)
		return

# 红色坦克的动画
func RedTank():
	$Timer.start()
func _on_timer_timeout() -> void:
	if isRed == false:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
		isRed = true
	else:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 192, 128, 16)
		isRed = false

# 黄色坦克的动画
func YellowTank():
	$Timer2.start()
func _on_timer_2_timeout() -> void:
	if isYellow == false:
		$Sprite2D.region_rect = Rect2(0, TankLevelNum * 16 + 64, 128, 16)
		isYellow = true
	else:
		if isRed == false and isRedTank > 0:
			$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 192, 128, 16)
			isRed = true
		else:
			$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
			isRed = false
		isYellow = false

# 绿色坦克的动画
func GreenTank():
	$Timer3.start()
func _on_timer_3_timeout() -> void:
	if isGreen == false:
		$Sprite2D.region_rect = Rect2(0, TankLevelNum * 16 + 192, 128, 16)
		isGreen = true
	else:
		if isRed == false and isRedTank > 0:
			$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 192, 128, 16)
			isRed = true
		else:
			$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
			isRed = false
		isGreen = false

# 黄绿合色坦克的动画
func YGColor():
	$Timer4.start()
func _on_timer_4_timeout() -> void:
	if isYellow == false:
		$Sprite2D.region_rect = Rect2(0, TankLevelNum * 16 + 64, 128, 16)
		isYellow = true
		return
	if isGreen == false:
		$Sprite2D.region_rect = Rect2(0, TankLevelNum * 16 + 192, 128, 16)
		isGreen = true
		return
	if isRed == false:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
		isRed = true
		return
	if isRed == true and isRedTank > 0:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 192, 128, 16)
		isRed = false
		isYellow = false
		isGreen = false
		return
	else:
		$Sprite2D.region_rect = Rect2(128, TankLevelNum * 16 + 64, 128, 16)
		isRed = false
		isYellow = false
		isGreen = false
		return

func _physics_process(delta: float) -> void:
	tankMove(move, delta)
	move_and_collide(velocity * delta)
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.y = move_toward(velocity.y, 0, speed)
	global_position = global_position.snapped(Vector2(4,4))
	if get_parent().isExplotion == true:
		TankExplotion()

func tankMove(m:int, _delta: float = 0) -> void:
	if get_parent().isRun == false:
		$AnimationPlayer.stop()
		return
	if m == 2:
		$AnimationPlayer.play("up")
		velocity.y = speed * -1
		global_position.x = round((global_position.x) / 32) * 32
		return
	if m == 3:
		$AnimationPlayer.play("right")
		velocity.x = speed * 1
		global_position.y = round((global_position.y) / 32) * 32
		return
	if m == 1:
		$AnimationPlayer.play("down")
		velocity.y = speed * 1
		global_position.x = round((global_position.x) / 32) * 32
		return
	if m == 4:
		$AnimationPlayer.play("left")
		velocity.x = speed * -1
		global_position.y = round((global_position.y) / 32) * 32
		return
func timeset():
	# 设置时间 随机在0-2之间 可以为小数
	$rollTime.wait_time = randf_range(0,2)
	$rollTime.start()

func _on_roll_time_timeout() -> void:
	# 随机数 1-4 将5转换为1(四个方向的概率为：上下左右 1:2:1:1)
	move = randi_range(1,5)
	if move == 5:
		move = 1
	timeset()

func mobTankBullet():
	if max_bullets > 0:
		if  get_parent().isRun == true:
			parent.createBullet(TankNum, move, global_position, TankLevelNum)
			max_bullets -= 1
		$BulletTime.wait_time = randf_range(0,3)
		$BulletTime.start()
func _on_bullet_time_timeout() -> void:
	mobTankBullet()
func _on_tank_area_2d_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "Bullet":
		if isRedTank > 0:
			isRedTank -= 1
			if isRedTank == 0:
				$Timer.stop()
			parent.addProp()
		if TankColor > 0:
			TankColor -= 1
			$Timer2.stop()
			$Timer3.stop()
			$Timer4.stop()
			$AudioStreamPlayer.play()
			TankInitColor(TankColor)
			return
		else:
			var isDead = false
			if isDead == false:
				isDead = true
				parent.tankExplotionScene(global_position,TankLevelNum,area.this_1p_or_2pBullet)
				parent.deadMobTank(TankNum)
				isDead = false

func TankExplotion():
	var isDead = false
	get_parent().exposition()
	if isDead == false:
		isDead = true
		parent.tankExplotionScene(global_position,TankLevelNum,-1)
		parent.deadMobTank(TankNum)
		isDead = false
