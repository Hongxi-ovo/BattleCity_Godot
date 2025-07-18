extends Node2D
# 实例化tank场景
@export var tank: PackedScene
# 实例化explotion场景
@export var explotion: PackedScene
# 实例化bullet场景
@export var bullet: PackedScene
# 实例化born场景
@export var born: PackedScene
# 定义当前是1p模式还是2p模式
@export var Player: int = 0
# 定义当前最大子弹数量
@export var MaxButtet: Vector2 = Vector2(1, 1)
# 定义1p和2p
var Player1
var Player2

var MobHave:bool = true

# 定义信号
signal PlayerLoadSucess

# 循环之前所执行的内容
func _ready() -> void:
	# 让Player的值为父节点的玩家数量
	Player = get_parent().PlayerNums
	tankBornInit()
# 坦克初始化
func tankBornInit():
	if Player == 1 and get_parent().getPlayLife(1) >= 1:
		tankBorn(1)
	if Player == 2:
		if get_parent().getPlayLife(1) >= 1:
			tankBorn(1)
		if get_parent().getPlayLife(2) >= 1:
			tankBorn(2)
	get_parent().mobTankBorn()
# 坦克生成(用于被敌方击毁后的再次生成)
func tankBorn(PlayersNum: int):
	if PlayersNum == 1:
		var Tank1 = tank.instantiate()
		var Born1 = born.instantiate()
		Tank1.PlayerNum = 0
		Born1.position = Vector2(352, 832)
		Tank1.position = Vector2(352, 832)
		if get_parent().MapArr[4][12] != null:
			get_parent().MapArr[4][12].queue_free()
		add_child(Born1)
		await Born1.animation_finished_and_freed
		Player1 = Tank1
		add_child(Tank1)
	if PlayersNum == 2:
		var Tank2 = tank.instantiate()
		var Born2 = born.instantiate()
		Tank2.PlayerNum = 1
		Born2.position = Vector2(608, 832)
		Tank2.position = Vector2(608, 832)
		if get_parent().MapArr[8][12] != null:
			get_parent().MapArr[8][12].queue_free()
		add_child(Born2)
		await Born2.animation_finished_and_freed
		Player2 = Tank2
		add_child(Tank2)
# 创建玩家的子弹
func createBullet(PlayersNum, bulletDirection, gPosition , TankLevelNum):
	var createScene = bullet.instantiate()
	createScene.BulletType = TankLevelNum
	createScene.bullet_direction = bulletDirection
	createScene.this_1p_or_2pBullet = PlayersNum + 1
	createScene.position = gPosition

	if PlayersNum == 0:
		createScene.collision_layer += 16
		createScene.collision_mask += 64 + 512
	if PlayersNum == 1:
		createScene.collision_layer += 32
		createScene.collision_mask += 128 + 256
	add_child(createScene)
# 最大子弹数量
func fillBullet(PlayerNum):
	if PlayerNum == 1 and Player1 != null:
		Player1.max_bullets += 1
	if PlayerNum == 2 and Player2 != null:
		Player2.max_bullets += 1
# 爆炸场景
func explotionScene(BulletPosition):
	var createExplotion = explotion.instantiate()
	createExplotion.Type = 0
	createExplotion.position = BulletPosition
	add_child(createExplotion)
func tankExplotionScene(BulletPosition,PlayerNum):
	var createExplotion = explotion.instantiate()
	createExplotion.Type = 1
	createExplotion.position = BulletPosition
	add_child(createExplotion)
	get_parent().setPlayLife(get_parent().getPlayLife(PlayerNum + 1) - 1,PlayerNum + 1)
	if PlayerNum == 0:
		Player1.queue_free()
		get_parent().setTankLevel(0,1)
		$"1PTimer".start()
	elif PlayerNum == 1:
		Player2.queue_free()
		get_parent().setTankLevel(0,2)
		$"2PTimer".start()
	$Audio.play()
	isGameOver()

func AudioPlay1(num):
	if MobHave == false:
		$AudioTankMove3.volume_db = -80
	if num != 0 and num != 5:
		if $AudioTankMove1.playing == false and $AudioTankMove2.playing == false:
			$AudioTankMove1.play()
		$AudioTankMove3.stop()
	else:
		$AudioTankMove1.stop()
		if $AudioTankMove3.playing == false and $AudioTankMove1.playing == false and $AudioTankMove2.playing == false:
			$AudioTankMove3.play()
func AudioPlay2(num):
	if MobHave == false:
		$AudioTankMove3.volume_db = -80
	if num != 0 and num != 5:
		if $AudioTankMove2.playing == false and $AudioTankMove1.playing == false:
			$AudioTankMove2.play()
		$AudioTankMove3.stop()
	else:
		$AudioTankMove2.stop()
		if $AudioTankMove3.playing == false and $AudioTankMove1.playing == false and $AudioTankMove2.playing == false:
			$AudioTankMove3.play()

func TankMainFree():
	queue_free()

func _on_1p_timer_timeout() -> void:
	if get_parent().getPlayLife(1) > 0:
		tankBorn(1)
	else:
		get_parent().GameOver(1)
func _on_2p_timer_timeout() -> void:
	if get_parent().getPlayLife(2) > 0:
		tankBorn(2)
	else:
		get_parent().GameOver(2)
func tankPause():
	get_parent().Pause()

func getTankLevel(PlayerNum):
	return get_parent().getTankLevel(PlayerNum)
func setTankLevel(PlayerNum):
	if PlayerNum == 1:
		Player1.getTankLevel(PlayerNum)
	elif PlayerNum == 2:
		Player2.getTankLevel(PlayerNum)
func tankShield(PlayerNum):
	if PlayerNum == 1:
		Player1.tankShield()
	elif PlayerNum == 2:
		Player2.tankShield()

func isGameOver():
	if get_parent().getPlayLife(1) < 1 and get_parent().getPlayLife(2) < 1:
		get_parent().stopAudio(3)
