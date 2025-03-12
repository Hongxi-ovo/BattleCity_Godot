extends Node2D
# 实例化tank场景
@export var mobTank: PackedScene
# 实例化explotion场景
@export var explotion: PackedScene
# 实例化bullet场景
@export var mobBullet: PackedScene
# 实例化born场景
@export var born: PackedScene
# 定义所有敌人坦克数量
@export var MobTankNums: int = 20
# 显示分数场景
@export var ScoreScene: PackedScene
# 道具场景
@export var PropScene: PackedScene
# 当前剩余敌人坦克数量
var MobTankNumsNow: int = MobTankNums
# 当前生成的坦克
var MobTankBorn: int = 0
var TankArr
# 是否坦克爆炸
var isExplotion: bool = false
# 生成上限 6个
@export var MobTankMaxNums: int = 6
# 当前场上敌人坦克数量
var MobTankNowNums: int = 0
# 定义敌人坦克存储数组
var MobTankArray = {}
# 定义第id个敌人坦克是否被击毁 并初始化false
var MobTankIsDead = {}

var isRun: bool = true

func _ready() -> void:
	for i in range(0, MobTankNums):
		MobTankIsDead[i] = false
	TankArr = loadFileTank()


# 敌方坦克初始化
func mobTankBornInit():
	if MobTankNowNums < MobTankMaxNums and MobTankNumsNow > 0:
		MobTankNowNums += 1
		MobTankArray[MobTankNumsNow] = mobTank.instantiate()
		var Born = born.instantiate()
		MobTankArray[MobTankNumsNow].TankColor = TankArr[MobTankBorn][0]
		MobTankArray[MobTankNumsNow].TankLevelNum = TankArr[MobTankBorn][1]
		MobTankArray[MobTankNumsNow].isRedTank = TankArr[MobTankBorn][2]
		MobTankBorn += 1
		MobTankArray[MobTankNumsNow].TankNum = MobTankNumsNow
		if MobTankNumsNow %3 == 0:
			Born.position = Vector2(96, 64)
			MobTankArray[MobTankNumsNow].position = Vector2(96, 64)
			if get_parent().MapArr[0][0] != null:
				get_parent().MapArr[0][0].queue_free()
		if MobTankNumsNow %3 == 2:
			Born.position = Vector2(480, 64)
			MobTankArray[MobTankNumsNow].position = Vector2(480, 64)
			if get_parent().MapArr[6][0] != null:
				get_parent().MapArr[6][0].queue_free()
		if MobTankNumsNow %3 == 1:
			Born.position = Vector2(864, 64)
			MobTankArray[MobTankNumsNow].position = Vector2(864, 64)
			if get_parent().MapArr[12][0] != null:
				get_parent().MapArr[12][0].queue_free()
		add_child(Born)
		get_parent().MobTankNum()
		await Born.animation_finished_and_freed
		add_child(MobTankArray[MobTankNumsNow])

		MobTankNumsNow -= 1
func loadFileTank():
	var config = ConfigFile.new()
	var fileName = str(get_parent().MapLevel) + ".tank"
	var filePath = config.load("res://MobTank//Level//" + fileName)
	if filePath != OK:
		print("加载出错")
		return 0
	# 读取配置文件
	# [颜色(控制坦克耐久的，范围为0-3)，
	# 等级(控制坦克样式的，不同样式的坦克有不一样的效果，范围在0-3),
	# 是否有道具(有几个道具，范围在0-4)]
	return (config.get_value("Level","TankArr"))

func _on_timer_timeout() -> void:
	mobTankBornInit()
func explotionScene(BulletPosition):
	var createExplotion = explotion.instantiate()
	createExplotion.Type = 0
	createExplotion.position = BulletPosition
	add_child(createExplotion)
func tankExplotionScene(BulletPosition, TankLevelNum , BulletPlayer):
	var createExplotion = explotion.instantiate()
	createExplotion.Type = 1
	createExplotion.position = BulletPosition
	add_child(createExplotion)
	$AudioStreamPlayer.play()
	await createExplotion.animation_finished_and_freed
	if BulletPlayer == -1:
		pass
	else :
		var addScore = ScoreScene.instantiate()
		addScore.score = 100 * (TankLevelNum + 1)
		addScore.position = BulletPosition
		get_parent().addScore(TankLevelNum + 1, BulletPlayer)
		add_child(addScore)

func addProp():
	var createProp = PropScene.instantiate()
	# 为避免报错 改用call_deferred创建子节点
	call_deferred("add_child", createProp)

func createBullet(PlayersNum, bulletDirection, gPosition, level):
	var createScene = mobBullet.instantiate()
	if level == 2:
		createScene.BulletType = 1
	createScene.bullet_direction = bulletDirection
	createScene.thisMobBullet = PlayersNum
	createScene.position = gPosition
	add_child(createScene)

func fillBullet(PlayerNum):
	if MobTankIsDead[PlayerNum - 1] == false:
		MobTankArray[PlayerNum].max_bullets += 1

func deadMobTank(PlayerNum):
	MobTankIsDead[PlayerNum - 1] = true
	MobTankArray[PlayerNum].queue_free()
	MobTankNowNums -= 1
	MobTankNums -= 1
	print(MobTankNums)
	if MobTankNumsNow == 0 and MobTankNowNums == 0 and MobTankNums <= 0:
		get_parent().stopAudio()

func eatProp(propPosition,PlayerNum,propNum):
	var addScore = ScoreScene.instantiate()
	addScore.score = 500
	addScore.position = propPosition
	get_parent().addPropScore(5, PlayerNum + 1)
	add_child(addScore)
	if propNum != 5:
		$eatProp.play()
		# 无敌
		if propNum == 0:
			get_parent().tankShield(PlayerNum + 1)
		# 暂停
		elif propNum == 1:
			isRun = false
			$propPause.start()
		# 铲子
		elif propNum == 2:
			get_parent().shovelProp()
		# 星星
		elif propNum == 3:
			get_parent().setTankLevel(get_parent().getTankLevel(PlayerNum + 1) + 1,PlayerNum + 1)
		# 炸弹
		elif propNum == 4:
			isExplotion = true
		# 加3级
		elif propNum == 6:
			get_parent().setTankLevel(get_parent().getTankLevel(PlayerNum + 1) + 3,PlayerNum + 1)
	else:
		# 加命
		$"1UPProp".play()
		get_parent().setPlayLife(get_parent().getPlayLife(PlayerNum + 1) + 1, PlayerNum + 1)

func _on_prop_pause_timeout() -> void:
	isRun = true

# 控制爆炸的
var exNum = 0
func exposition():
	if exNum <= MobTankNowNums:
		exNum += 1
	else :
		exNum = 0
		isExplotion = false
