extends Node2D
# 当前关卡 
var stage:int = 1
var score:Vector2i = Vector2i(0,20000)
var playerScore:Vector2i = Vector2i(0,0)
var is_two_player_mode: bool = true
# 记录1p2p击杀坦克的数量和类型
# 第一行: 5 3 3 1 (1p击杀坦克数)
# 第二行: 1 2 2 1 (2p击杀坦克数)
# 数字代表不同类型坦克的击杀数量
# 从左到右依次为: 普通、快速、加强、装甲坦克
var tank_array = [[0,0,0,0],[0,0,0,0]]
var addTanks = [[0,0,0,0],[0,0,0,0]]
var ThisTank:int = 0
# Called when the node enters the scene tree for the first time.

# 定义一个信号，结算完成后发送信号
signal scoreSuccess
func _ready() -> void:
	# 初始化分数
	$NodeScore/score.text = str(score.y)
	# 初始化关卡
	$NodeScore/STAGENUM.text = str(stage)
	# 初始化玩家分数
	$"Node1P/1pNUM".text = str(playerScore.x)
	$"Node2P/2pNUM".text = str(playerScore.y)
	# 如果是双人模式
	if is_two_player_mode:
		$Node2P.visible = true
	$NextTime.start()

func _on_timer_timeout() -> void:
	addScore()

func _on_next_time_timeout() -> void:
	if ThisTank == 0:
		$"Node1P/1pScore1".visible = true
		$"Node1P/1pKillTank1".visible = true
		$"Node2P/2pScore1".visible = true
		$"Node2P/2pKillTank1".visible = true
	if ThisTank == 1:
		$"Node1P/1pScore2".visible = true
		$"Node1P/1pKillTank2".visible = true
		$"Node2P/2pScore2".visible = true
		$"Node2P/2pKillTank2".visible = true
	if ThisTank == 2:
		$"Node1P/1pScore3".visible = true
		$"Node1P/1pKillTank3".visible = true
		$"Node2P/2pScore3".visible = true
		$"Node2P/2pKillTank3".visible = true
	if ThisTank == 3:
		$"Node1P/1pScore4".visible = true
		$"Node1P/1pKillTank4".visible = true
		$"Node2P/2pScore4".visible = true
		$"Node2P/2pKillTank4".visible = true
	if ThisTank == 4:
		$"Node1P/1pAllKillTank".visible = true
		$"Node2P/2pAllKillTank".visible = true
		$"Node1P/1pAllKillTank".text = str(tank_array[0][0] + tank_array[0][1] + tank_array[0][2] + tank_array[0][3])
		$"Node2P/2pAllKillTank".text = str(tank_array[1][0] + tank_array[1][1] + tank_array[1][2] + tank_array[1][3])
		$AudioStreamPlayer.play()
		$rewardTimer.start()
		return
	addScore()
# 计算分数
func addScore():
	var isHave = false
	if tank_array[0][ThisTank] > addTanks[0][ThisTank]:
		addTanks[0][ThisTank] += 1
		if ThisTank == 0:
			$"Node1P/1pKillTank1".text = str(addTanks[0][ThisTank])
			$"Node1P/1pScore1".text = str(addTanks[0][ThisTank] * 100)
		if ThisTank == 1:
			$"Node1P/1pKillTank2".text = str(addTanks[0][ThisTank])
			$"Node1P/1pScore2".text = str(addTanks[0][ThisTank] * 200)
		if ThisTank == 2:
			$"Node1P/1pKillTank3".text = str(addTanks[0][ThisTank])
			$"Node1P/1pScore3".text = str(addTanks[0][ThisTank] * 300)
		if ThisTank == 3:
			$"Node1P/1pKillTank4".text = str(addTanks[0][ThisTank])
			$"Node1P/1pScore4".text = str(addTanks[0][ThisTank] * 400)
		isHave = true
	if tank_array[1][ThisTank] > addTanks[1][ThisTank]:
		addTanks[1][ThisTank] += 1
		if ThisTank == 0:
			$"Node2P/2pKillTank1".text = str(addTanks[1][ThisTank])
			$"Node2P/2pScore1".text = str(addTanks[1][ThisTank] * 100)
		if ThisTank == 1:
			$"Node2P/2pKillTank2".text = str(addTanks[1][ThisTank])
			$"Node2P/2pScore2".text = str(addTanks[1][ThisTank] * 200)
		if ThisTank == 2:
			$"Node2P/2pKillTank3".text = str(addTanks[1][ThisTank])
			$"Node2P/2pScore3".text = str(addTanks[1][ThisTank] * 300)
		if ThisTank == 3:
			$"Node2P/2pKillTank4".text = str(addTanks[1][ThisTank])
			$"Node2P/2pScore4".text = str(addTanks[1][ThisTank] * 400)
		isHave = true
	if isHave == true:
		$AudioStreamPlayer.play()
		$Timer.start()
	else:
		ThisTank += 1
		$NextTime.start()

func _on_reward_timer_timeout() -> void:
	if is_two_player_mode:
		if int($"Node1P/1pAllKillTank".text) > int($"Node2P/2pAllKillTank".text):
			$"Node1P/1pBONUS".visible = true
			$"Node1P/1pAddPTS".visible = true
			$"Node1P/1pNUM".text = str(playerScore.x + 1000)
			get_parent().playingScore.x += 1000
		elif int($"Node1P/1pAllKillTank".text) < int($"Node2P/2pAllKillTank".text):
			$"Node2P/2pBONUS".visible = true
			$"Node2P/2pAddPTS".visible = true
			$"Node2P/2pNUM".text = str(playerScore.y + 1000)
			get_parent().playingScore.y += 1000
		else:
			$"Node1P/1pBONUS".visible = true
			$"Node1P/1pAddPTS".visible = true
			$"Node2P/2pBONUS".visible = true
			$"Node2P/2pAddPTS".visible = true
			$"Node1P/1pNUM".text = str(playerScore.x + 1000)
			$"Node2P/2pNUM".text = str(playerScore.y + 1000)
			get_parent().playingScore.x += 1000
			get_parent().playingScore.y += 1000
		$AudioAward.play()
	$Timer2.start()


func _on_timer_2_timeout() -> void:
	emit_signal( "scoreSuccess" )
