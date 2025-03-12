extends Node2D

# BulidNum表示当前这个Block的方块类型
@export var BuildNum: int = 0


# 展示前加载的内容
func _ready() -> void:
	build(BuildNum)
	
func build(Num: int):
	# none
	if Num == 0:
		nullBlock()
		return
	# brick
	if Num >= 1 and Num <= 5:
		brickBlock()
		BlockType(Num - 1)
		return
	# iron
	if Num >= 6 and Num <= 10:
		ironBlock()
		BlockType(Num - 6)
		return
	# water
	if Num == 11:
		waterBlock()
		allBlock()
		return
	# glass
	if Num == 12:
		kusaBlock()
		allBlock()
		return
	# ice
	if Num == 13:
		iceBlock()
		allBlock()
		return
	if Num == 15:
		brickBlock()
		BlockType(5)
		return
	if Num == 16:
		brickBlock()
		BlockType(6)
		return
	pass


func BlockType(Num: int):
	match Num:
		0:
			$Sprite2D.visible = true
			$Sprite2D2.visible = false
			$Sprite2D3.visible = true
			$Sprite2D4.visible = false
			return
		1:
			$Sprite2D.visible = true
			$Sprite2D2.visible = true
			$Sprite2D3.visible = false
			$Sprite2D4.visible = false
			return
		2:
			$Sprite2D.visible = false
			$Sprite2D2.visible = true
			$Sprite2D3.visible = false
			$Sprite2D4.visible = true
			return
		3:
			$Sprite2D.visible = false
			$Sprite2D2.visible = false
			$Sprite2D3.visible = true
			$Sprite2D4.visible = true
			return
		4:
			$Sprite2D.visible = true
			$Sprite2D2.visible = true
			$Sprite2D3.visible = true
			$Sprite2D4.visible = true
			return
		5:
			$Sprite2D.visible = true
			$Sprite2D2.visible = false
			$Sprite2D3.visible = false
			$Sprite2D4.visible = false
			return
		6:
			$Sprite2D.visible = false
			$Sprite2D2.visible = true
			$Sprite2D3.visible = false
			$Sprite2D4.visible = false
			return
		7:
			$Sprite2D.visible = false
			$Sprite2D2.visible = false
			$Sprite2D3.visible = true
			$Sprite2D4.visible = false
			return
		8:
			$Sprite2D.visible = false
			$Sprite2D2.visible = true
			$Sprite2D3.visible = false
			$Sprite2D4.visible = true
			return

func brickBlock():
	var BlockRect = Rect2(40, 0, 8, 8)
	$Sprite2D.region_rect = BlockRect
	$Sprite2D2.region_rect = BlockRect
	$Sprite2D3.region_rect = BlockRect
	$Sprite2D4.region_rect = BlockRect

func ironBlock():
	var BlockRect = Rect2(16, 0, 8, 8)
	$Sprite2D.region_rect = BlockRect
	$Sprite2D2.region_rect = BlockRect
	$Sprite2D3.region_rect = BlockRect
	$Sprite2D4.region_rect = BlockRect

func waterBlock():
	var BlockRect = Rect2(16, 8, 8, 8)
	$Sprite2D.region_rect = BlockRect
	$Sprite2D2.region_rect = BlockRect
	$Sprite2D3.region_rect = BlockRect
	$Sprite2D4.region_rect = BlockRect

func kusaBlock():
	var BlockRect = Rect2(24, 0, 8, 8)
	$Sprite2D.region_rect = BlockRect
	$Sprite2D2.region_rect = BlockRect
	$Sprite2D3.region_rect = BlockRect
	$Sprite2D4.region_rect = BlockRect

func iceBlock():
	var BlockRect = Rect2(32, 0, 8, 8)
	$Sprite2D.region_rect = BlockRect
	$Sprite2D2.region_rect = BlockRect
	$Sprite2D3.region_rect = BlockRect
	$Sprite2D4.region_rect = BlockRect

func nullBlock():
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
	$Sprite2D3.visible = false
	$Sprite2D4.visible = false

func allBlock():
	$Sprite2D.visible = true
	$Sprite2D2.visible = true
	$Sprite2D3.visible = true
	$Sprite2D4.visible = true
