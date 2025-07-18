extends Node2D
var AllNum = 0


func TankBorn():
	AllNum += 1
	match AllNum:
		1:
			$Node2D/Sprite2D20.visible = false
		2:
			$Node2D/Sprite2D19.visible = false
		3:
			$Node2D/Sprite2D18.visible = false
		4:
			$Node2D/Sprite2D17.visible = false
		5:
			$Node2D/Sprite2D16.visible = false
		6:
			$Node2D/Sprite2D15.visible = false
		7:
			$Node2D/Sprite2D14.visible = false
		8:
			$Node2D/Sprite2D13.visible = false
		9:
			$Node2D/Sprite2D12.visible = false
		10:
			$Node2D/Sprite2D11.visible = false
		11:
			$Node2D/Sprite2D10.visible = false
		12:
			$Node2D/Sprite2D9.visible = false
		13:
			$Node2D/Sprite2D8.visible = false
		14:
			$Node2D/Sprite2D7.visible = false
		15:
			$Node2D/Sprite2D6.visible = false
		16:
			$Node2D/Sprite2D5.visible = false
		17:
			$Node2D/Sprite2D4.visible = false
		18:
			$Node2D/Sprite2D3.visible = false
		19:
			$Node2D/Sprite2D2.visible = false
		20:
			$Node2D/Sprite2D.visible = false
		
func Tank1Life(num:int):
	if num == 0:
		$"1p/life".text = "0"
	else:
		$"1p/life".text = str(num - 1)
func Tank2Life(num:int):
	if num == 0:
		$"2p/life".text = "0"
	else:
		$"2p/life".text = str(num - 1)
func StageInit(num:int):
	$Stage.text = str(num)
func pause():
	$Pause.audioPlay()
	get_parent().get_tree().paused = true

func gameOver(playerNum:int):
	if playerNum == 1 and $GameOver/Over.visible == false:
		$"GameOver/1P".visible = true
	elif playerNum == 2 and $GameOver/Over.visible == false:
		$"GameOver/2P".visible = true
	if ($"GameOver/1P".visible == true and $"GameOver/2P".visible == true) or get_parent().get_parent().PlayerLife == Vector2i(0,0):
		Over()

func gameModel(isTowPlayerModel:bool):
	if isTowPlayerModel == true:
		$"1p".visible = true
		$"2p".visible = true
	else:
		$"1p".visible = true
		$"2p".visible = false
	
func Over():
	$"GameOver/1P".visible = false
	$"GameOver/2P".visible = false
	$GameOver/Over.visible = true
