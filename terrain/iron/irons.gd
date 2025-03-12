extends Node2D
@export var iron: PackedScene

@export var ironBuildNum: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build(ironBuildNum)
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
	$Sprite2D3.visible = false
	$Sprite2D4.visible = false

func build(Num: int = 0):
	var ironBuild = [1, 1, 1, 1]
	match Num:
		0:
			ironBuild = [0, 1, 0, 1]
		1:
			ironBuild = [0, 0, 1, 1]
		2:
			ironBuild = [1, 0, 1, 0]
		3:
			ironBuild = [1, 1, 0, 0]
		4:
			ironBuild = [1, 1, 1, 1]
		5:
			ironBuild = [1, 0, 0, 0]
		6:
			ironBuild = [0, 1, 0, 0]
		7:
			ironBuild = [0, 0, 1, 0]
		8:
			ironBuild = [0, 0, 0, 1]

	var ironExample = [0, 0, 0, 0]
	for i in ironBuild.size():
		if ironBuild[i] == 1:
			ironExample[i] = iron.instantiate()
			ironExample[i].set("ironPosition", i)
			add_child(ironExample[i])

func AudioSelect(num: int = 1):
	if num != 2:
		$Audio2.play()
	if num == 2:
		$Audio.play()
