extends TileMapLayer

# 实例化 砖块、铁块、水、草、冰的场景
@export var brick: PackedScene
@export var iron: PackedScene
@export var water: PackedScene
@export var kusa: PackedScene
@export var ice: PackedScene
# 实例化坦克场景
@export var TankMain: PackedScene
# 实例化敌方坦克场景
@export var MobTankMain: PackedScene
# 实例化UI场景
@export var UI: PackedScene

# 负责发出当前场景结束的信号，表示可以到下一关卡
var TankBornS
var MobTankMainS
var UIScene
# [0,0]所在坐标
var initPosition: Vector2 = Vector2(96, 64)
# 玩家数量
var PlayerNums:int = 1
# 地图关卡
var MapLevel:int = 1
# 通过记录地图块的坐标来确定场景的生成
var MapArr = []
# 循环前加载的内容
func _ready() -> void:
	# print($WallArea2D.custom_class_name)
	# 如果自定义地图为否的话 则直接加载地图关卡
	# 初始化地图块
	for i in range(13):
		var row = []
		for j in range(13):
			row.append(null)
		MapArr.append(row)
	MapLevel = get_parent().SelectLevel
	UIScene = UI.instantiate()
	UIScene.StageInit(MapLevel)
	UIScene.Tank1Life(getPlayLife(1))
	UIScene.Tank2Life(getPlayLife(2))
	add_child(UIScene) 
	
	get_parent().tank_array =  [[0,0,0,0],[0,0,0,0]]
	if get_parent().IsCONTRUCTION == false:
		Build(loadMapData((MapLevel - 1 ) % 35))
	else:
		Build(get_parent().SaveMap)
		get_parent().IsCONTRUCTION = false
# 加载外部存储的map文件
func loadMapData(level: int):
	var config = ConfigFile.new()
	var fileName = str(level + 1) + ".map"
	var filePath = config.load("res://Map//Level//" + fileName)
	if filePath != OK:
		print("加载出错")
		return
	# 读取内容
	return (config.get_value("Level", "MapArr"))
	
	
func Build(BuildNum):
	for i in 13:
		for j in 13:
			BulidBlock(BuildNum[i][j], i, j)
	if MapArr[6][12] != null:
		MapArr[6][12].queue_free()

func BulidBlock(num, i, j):
	# 根据num的值 来实例化不同的场景
	if num >= 1 and num <= 5:
		MapArr[i][j] = brick.instantiate()
		MapArr[i][j].brickBuildNum = num - 1
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num >= 6 and num <= 10:
		MapArr[i][j] = iron.instantiate()
		MapArr[i][j].ironBuildNum = num - 6
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num == 11:
		MapArr[i][j] = water.instantiate()
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num == 12:
		MapArr[i][j] = kusa.instantiate()
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num == 13:
		MapArr[i][j] = ice.instantiate()
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num == 15:
		MapArr[i][j] = brick.instantiate()
		MapArr[i][j].brickBuildNum = 8
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])
	elif num == 16:
		MapArr[i][j] = brick.instantiate()
		MapArr[i][j].brickBuildNum = 7
		MapArr[i][j].position = initPosition + Vector2(64 * i, 64 * j)
		add_child(MapArr[i][j])

# 控制坦克出生的
func TankBorn():
	TankBornS = TankMain.instantiate()
	add_child(TankBornS)

func mobTankBorn():
	MobTankMainS = MobTankMain.instantiate()
	add_child(MobTankMainS)
# 如果有接收到子弹撞击到墙面，则发出声音
func _on_wall_area_2d_area_entered(area: Area2D) -> void:
	if area.custom_class_name == "Bullet":
		$AudioSteelhit.play()

# 接受子级传来的分数，增加到父级的分数列表中
func addScore(num , player):
	if player == 1:
		get_parent().playingScore.x += num * 100
		get_parent().tank_array[0][num - 1] += 1
		return
	elif player ==2:
		get_parent().playingScore.y += num * 100
		get_parent().tank_array[1][num - 1] += 1
		return
func addPropScore(num ,player):
	if player == 1:
		get_parent().playingScore.x += num * 100
		return
	elif player ==2:
		get_parent().playingScore.y += num * 100
		return
func stopAudio():
	TankBornS.MobHave = false
	$Timer.start()
func _on_timer_timeout() -> void:
	get_parent().ScoreScene()
	TankBornS.TankMainFree()
func mapFree():
	queue_free()
func MobTankNum():
	UIScene.TankBorn()
# 使用getter和setter来控制玩家的生命值和等级
func getPlayLife(player):
	if player == 1:
		return get_parent().PlayerLife.x
	elif player == 2:
		return get_parent().PlayerLife.y
func setPlayLife(num, player):
	if player == 1:
		get_parent().PlayerLife.x = num
		UIScene.Tank1Life(getPlayLife(1))
	elif player == 2:
		get_parent().PlayerLife.y = num
		UIScene.Tank2Life(getPlayLife(2))
func getTankLevel(player):
	if player == 1:
		return get_parent().TankLevel.x
	elif player == 2:
		return get_parent().TankLevel.y
func setTankLevel(num,player):
	if num >= 3:
		num = 3
	if player == 1:
		get_parent().TankLevel.x = num
		TankBornS.setTankLevel(player)
	elif player == 2:
		get_parent().TankLevel.y = num
func Pause():
	UIScene.pause()
func tankShield(player):
	TankBornS.tankShield(player)

func BuildIron():
	var arr = [[5,11,8],[6,11,1],[7,11,7],[5,12,0],[7,12,2]]
	for a in 5:
		MapArr[arr[a][0]][arr[a][1]].queue_free()
		MapArr[arr[a][0]][arr[a][1]] = iron.instantiate()
		MapArr[arr[a][0]][arr[a][1]].ironBuildNum = arr[a][2]
		MapArr[arr[a][0]][arr[a][1]].position = initPosition + Vector2(64 * arr[a][0], 64 * arr[a][1])
		call_deferred("add_child", MapArr[arr[a][0]][arr[a][1]])
func BuildBrick():
	var arr = [[5,11,8],[6,11,1],[7,11,7],[5,12,0],[7,12,2]]
	for a in 5:
		MapArr[arr[a][0]][arr[a][1]].queue_free()
		MapArr[arr[a][0]][arr[a][1]] = brick.instantiate()
		MapArr[arr[a][0]][arr[a][1]].brickBuildNum = arr[a][2]
		MapArr[arr[a][0]][arr[a][1]].position = initPosition + Vector2(64 * arr[a][0], 64 * arr[a][1])
		call_deferred("add_child", MapArr[arr[a][0]][arr[a][1]])

func shovelProp():
	BuildIron()
	$shovelPropTimer.start()


func _on_shovel_prop_timer_timeout() -> void:
	$shovelPropTimeOver.start()
	$IronBrickTimer.start()
func _on_shovel_prop_time_over_timeout() -> void:
	$IronBrickTimer.stop()
	isShovel = false
	BuildBrick()

var isShovel = false
func _on_iron_brick_timer_timeout() -> void:
	if isShovel == false:
		BuildBrick()
		isShovel = true
	else:
		BuildIron()
		isShovel = false
