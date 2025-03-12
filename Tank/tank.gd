extends CharacterBody2D
# 设置坦克的速度
@export var speed = 240
# 设置坦克的爆炸场景
@export var exploration: PackedScene
# 当前的玩家编号(0->1 1->2)
@export var PlayerNum: int = 0
# 坦克等级（0 1 2 3）
@export var TankLevelNum: int = 0

# 当前场上自己最多可以存在的子弹数量
var max_bullets = 1
# 控制子弹的移动方向
var bullet_direction = 1
# 锁定当前的移动状态
var move = 0
var MOVEMAIN: int = 0
var PlayersBullet: int
# 定义父节点
var parent
# 定义一个ice相关移动的变量
var iceMove: int = 0
# 循环之前所运行的内容
func _ready() -> void:
	parent = get_parent()
	TankLevelNum = get_parent().getTankLevel(PlayerNum + 1)
	TankInit(PlayerNum, TankLevelNum)
	move = 0

# 循环 根据物理引擎刷新
func _physics_process(delta: float) -> void:
	AudioTank(PlayerNum)
	# 控制移动部分的代码
	control_movement(delta)
	# 检测碰撞并处理
	move_and_collide(velocity * delta)
	# 将小数转换为整数
	global_position = global_position.snapped(Vector2(4,4))

# 根据当前是1P或者2P的移动，来播放坦克移动的声音
func AudioTank(Num):
	if Num == 0:
		get_parent().AudioPlay1(move)
	if Num == 1:
		get_parent().AudioPlay2(move)

# 需要传入参数
# 1p?2P? Player
# 当前坦克等级 0，1，2，3 与之对应的子弹也会改变
# 
func TankInit(Player: int = 0, TankLevel: int = 0):
	$Shield/ShieldAnimationPlayer.play("shield")
	$AnimationPlayer.play("up")
	$Sprite2D.region_rect = Rect2(0, 128 * Player + TankLevel * 16, 128, 16)
	if TankLevelNum >= 2:
		max_bullets = 2
	else:
		max_bullets = 1
	if PlayerNum == 0:
		PlayersBullet = 1
		$TankArea2D.collision_layer += 128 # 1p所在物理层
		$TankArea2D.collision_mask += 32 # 1p扫描物理层
		$Shield.collision_layer += 256 # 1p保护层
	if PlayerNum == 1:
		PlayersBullet = 2
		$TankArea2D.collision_layer += 64 # 2p所在物理层
		$TankArea2D.collision_mask += 16 # 2p扫描物理层
		$Shield.collision_layer += 512 # 2p保护层
# 坦克升级之类的部分
func getTankLevel(Player):
	print("打印了，PlayerNum是" + str(PlayerNum))
	TankLevelNum = get_parent().getTankLevel(Player)
	TankInitLevel(PlayerNum, TankLevelNum)


func TankInitLevel(Player: int = 0, TankLevel: int = 0):
	$Sprite2D.region_rect = Rect2(0, 128 * Player + TankLevel * 16, 128, 16)
	if TankLevelNum >= 2:
		max_bullets = 2
	else:
		max_bullets = 1
func tankShield():
	$Shield/ShieldSprite2D.visible = true
	$TankArea2D/CollisionShape2D.disabled = true
	$Shield/CollisionShape2D.disabled = false
	$Shield/ShieldTimer.wait_time = 10
	$Shield/ShieldTimer.start()

# 控制坦克移动部分
func control_movement(_delta):
	if Input.is_action_just_pressed("a" + str(PlayerNum + 1)) and max_bullets > 0:
		max_bullets -= 1
		parent.createBullet(PlayerNum, bullet_direction, global_position,TankLevelNum)
		$AudioShoot.play()
	if Input.is_action_just_pressed("start" + str(PlayerNum + 1)):
		get_parent().tankPause()
	# 控制移动部分
	if (Input.is_action_pressed("up" + str(PlayerNum + 1)) and (move == 0 or move == 1)) or iceMove == 1:
		move = 1
		bullet_direction = move
		velocity.y = speed * -1
		global_position.x = round((global_position.x) / 32) * 32
		$AnimationPlayer.play("up")
		return
	if (Input.is_action_pressed("down" + str(PlayerNum + 1)) and (move == 0 or move == 2)) or iceMove == 2:
		move = 2
		bullet_direction = move
		velocity.y = speed * 1
		global_position.x = round((global_position.x) / 32) * 32
		$AnimationPlayer.play("down")
		return
	if (Input.is_action_pressed("left" + str(PlayerNum + 1)) and (move == 0 or move == 3)) or iceMove == 3:
		move = 3
		bullet_direction = move
		velocity.x = speed * -1
		global_position.y = round((global_position.y) / 32) * 32
		$AnimationPlayer.play("left")
		return
	if (Input.is_action_pressed("right" + str(PlayerNum + 1)) and (move == 0 or move == 4)) or iceMove == 4:
		move = 4
		bullet_direction = move
		velocity.x = speed * 1
		global_position.y = round((global_position.y) / 32) * 32
		$AnimationPlayer.play("right")
		return

	$AnimationPlayer.stop()
	move = MOVEMAIN
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.y = move_toward(velocity.y, 0, speed)

# 无敌时间结束后，释放Shield节点
func _on_shield_timer_timeout() -> void:
	$Shield/ShieldSprite2D.visible = false
	$Shield/CollisionShape2D.disabled = true
	$TankArea2D/CollisionShape2D.disabled = false

# 判断当前碰撞到的子弹是否为己方，是的话，则定住坦克一段时间

func _on_tank_area_2d_area_entered(area: Area2D) -> void:
	print("碰撞到了" + area.custom_class_name)
	if area.custom_class_name == "Bullet":
		MOVEMAIN = 5
		move = MOVEMAIN
		$RigidityTimer.start()
		$FlickerTimer.start()
	# 若是敌方子弹，则发生爆炸
	elif area.custom_class_name == 'MobBullet':
		MOVEMAIN = 5
		move = MOVEMAIN
		parent.tankExplotionScene(global_position,PlayerNum)
		queue_free()
# 当时间到了以后才可移动
func _on_rigidity_timer_timeout() -> void:
	MOVEMAIN = 0
	$Sprite2D.visible = true
	$FlickerTimer.stop()
# 控制定住坦克时的闪烁效果
func _on_flicker_timer_timeout() -> void:
	$Sprite2D.visible = !$Sprite2D.visible
# 在冰上移动的效果以及声音
func _on_ice_area_2d_area_entered(_area: Area2D) -> void:
	if iceMove == 0:
		iceMove = move
		$IceArea2D/Timer.start()
		$AudioIce.play()
# 在冰上移动的时间结束后
func _on_timer_timeout() -> void:
	iceMove = 0
