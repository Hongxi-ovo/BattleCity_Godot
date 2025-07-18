extends Node2D

@export var brick: PackedScene

@export var brickBuildNum: int = 0

var brickExample = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build(brickBuildNum)
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
	$Sprite2D3.visible = false
	$Sprite2D4.visible = false


func build(Num: int = 0):
	var brickBuild = [1, 1, 1, 1]
	match Num:
		0:
			brickBuild = [0, 1, 0, 1]
		1:
			brickBuild = [0, 0, 1, 1]
		2:
			brickBuild = [1, 0, 1, 0]
		3:
			brickBuild = [1, 1, 0, 0]
		4:
			brickBuild = [1, 1, 1, 1]
		5:
			brickBuild = [1, 0, 0, 0]
		6:
			brickBuild = [0, 1, 0, 0]
		7:
			brickBuild = [0, 0, 1, 0]
		8:
			brickBuild = [0, 0, 0, 1]
	for i in brickBuild.size():
		if brickBuild[i] == 1:
			buildmax(i)


func buildmax(num: int):
	brickExample[num] = [0, 0, 0, 0]
	for i in 4:
		brickExample[num][i] = brick.instantiate()
		brickExample[num][i].brickPosition = i
		brickExample[num][i].NumbrickPosition = num
		add_child(brickExample[num][i])

func freeMain(num):
	for i in 4:
		if brickExample[num][i] != null:
			brickExample[num][i].allDelete()

func AudioBrickhit():
	$AudioBrickhit.play()
