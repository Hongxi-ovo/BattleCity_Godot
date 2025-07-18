extends Node2D
# Title界面 是游戏开始时的默认界面
@export var Title: PackedScene
# 自定义地图时展示的地图
@export var mapSave: PackedScene
# 正常地图必有的地图内容
@export var mapMain: PackedScene
# 负责切换场景中过渡的动画场景
@export var SceneChange: PackedScene
# 导入分数合计的场景
@export var Score: PackedScene
# 这里负责记录所有的变量
# 玩家类(生命数量，坦克等级，...)
var GamePlayerNum: int = 0
# 当前所在关卡
var SelectLevel: int = 1
# 单人模式还是双人模式
var isTowPlayerModel: bool = false
# 1P和2P的生命数量
@export var PlayerLife: Vector2i = Vector2i(0, 0)
# 1P和2P的坦克等级
@export var TankLevel: Vector2 = Vector2(0, 0)
# 当前分数、玩家最高分数
@export var score: Vector2i = Vector2i(00, 20000)
# 记录1p和2p游玩中的分数
@export var playingScore: Vector2i = Vector2i(0, 0)
# 将动画场景赋给Change
var Change
# 若是使用了自定义地图 则使用下列矩阵加载地图
var IsCONTRUCTION: bool = false
var SaveMap = [0]
# 加载地图场景
var MapMain
var ScoreMain
var isTestModel = false

var tank_array = [[0,0,0,0],[0,0,0,0]]

signal loadOk
# 程序的入口
func _ready() -> void:
	Change = SceneChange.instantiate()
	StartScene() 
func _process(_delta: float) -> void:
	$RichTextLabel.text = "FPS:" + str(int(Performance.get_monitor(Performance.TIME_FPS)))
	if Input.is_action_just_pressed("Show FPS"):
		$RichTextLabel.visible = !$RichTextLabel.visible
	
	if Input.is_action_just_pressed("reload"):
		Change = SceneChange.instantiate()
		IsCONTRUCTION = false
		SaveMap = [0]
		for child in get_children():
			if str(child.name) != "Camera2D" and str(child.name) != "ColorRect" and str(child.name) != "RichTextLabel" and str(child.name) != "TestModel":
				child.queue_free()
		if playingScore.x >= playingScore.y:
			score.x = playingScore.x
		else:
			score.y = playingScore.y
		if score.x >= score.y:
			score.y = score.x
		PlayerLife = Vector2(3,3)
		TankLevel = Vector2(0,0)
		playingScore = Vector2(0,0)
		SelectLevel = 1
		isTowPlayerModel = false
		isTestModel = false
		$TestModel.visible = false
		$TestModel/Test.visible = false
		$TestModel/Timer.stop()
		StartScene()
		Change.queue_free()
func testModel():
	$TestModel.visible = true
	isTestModel = true
	$TestModel/AudioStreamPlayer2.play()
	$TestModel/Timer.start()
	

# 开始场景 即标题页面的内容 等标题内容结束之后进入切换场景页面
func StartScene():
	var TitleMain = Title.instantiate()
	TitleMain.I = str(score.x)
	TitleMain.Hi = str(score.y)
	add_child(TitleMain)
	# 等待TitleMain的TitleStop信号
	await TitleMain.TitleStop
	sceneChange(GamePlayerNum, TitleMain)

# 场景改变
func sceneChange(Num: int, Scene):
	Change = SceneChange.instantiate()
	Change.SelectNums = Num
	Change.isSelect = true
	Change.SelectLevel = SelectLevel
	add_child(Change)
	await loadOk
	Scene.queue_free()
	if Num == 0:
		isTowPlayerModel = false
		GameScene()
	if Num == 1:
		isTowPlayerModel = true
		GameScene()
	if Num == 2:
		Num = 0
		CONSTRUCTIONScene()
	if Num == 3:
		Num = 0
		StartScene()
	
# 游戏场景 根据Num的值来加载1P和2P
func GameScene():
	MapMain = mapMain.instantiate()
	if isTowPlayerModel:
		MapMain.PlayerNums = 2
	else:
		MapMain.PlayerNums = 1
	add_child(MapMain)
	await loadOk
	MapMain.TankBorn()

# 自定义场景
func CONSTRUCTIONScene():
	var CONScene = mapSave.instantiate()
	add_child(CONScene)
	await CONScene.MapSaveStop
	IsCONTRUCTION = true
	sceneChange(GamePlayerNum, CONScene)

# 负责发送当前场景是否加载完成的信号
func changeSceneSignal():
	emit_signal("loadOk")

# 计分场景
func ScoreScene(isOver):
	ScoreMain = Score.instantiate()
	ScoreMain.tank_array = tank_array
	ScoreMain.playerScore = playingScore
	ScoreMain.stage = SelectLevel
	ScoreMain.score = score
	ScoreMain.is_two_player_mode = isTowPlayerModel
	add_child(ScoreMain)
	await  ScoreMain.scoreSuccess
	if isOver:
		MapMain.mapFree()
		if playingScore.x >= playingScore.y:
			score.x = playingScore.x
		else:
			score.y = playingScore.y
		if score.x >= score.y:
			score.y = score.x
		TankLevel = Vector2(0,0)
		playingScore = Vector2(0,0)
		SelectLevel = 1
		isTowPlayerModel = false
		StartScene()
		ScoreMain.queue_free()
		Change.queue_free()
	else:
		SelectLevel += 1
		MapMain.mapFree()
		Change.SelectLevel = SelectLevel
		Change.changeStage(ScoreMain)
	
func _on_timer_timeout() -> void:
	$TestModel/Test.visible = !$TestModel/Test.visible
