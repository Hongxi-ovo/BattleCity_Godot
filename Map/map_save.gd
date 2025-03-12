extends TileMapLayer
# 导入了Blocks场景的内容
@export var Blocks: PackedScene
# 定义了一个数组 初始为空，若是再次打开编辑地图 则会将父节点的值复制过来，传给MapArray
var MapArray = []
# 定义了一个数组
var BlocksBulidMain = []
# 地图保存停止的信号
signal MapSaveStop
# 记录当前所选的方块内容
var selectBlock: int = 0


# 循环开始前的初始化内容
func _ready() -> void:
	# 获取父节点的SaveMap，如果SaveMap不存在内容的话，就按照下面的内容初始化内容
	if get_parent().SaveMap == [0]:
		for i in range(13):
			var row = []
			for j in range(13):
				row.append(0) # 每个元素初始化为 0
			MapArray.append(row)
		for i in range(13):
			var row1 = []
			for j in range(13):
				row1.append(null) # 每个元素初始化为 0
			BlocksBulidMain.append(row1)
		# 默认基地周边生成的砖块
		centerBlock(Vector2(5, 12), 1)
		centerBlock(Vector2(5, 11), 15)
		centerBlock(Vector2(6, 11), 2)
		centerBlock(Vector2(7, 11), 16)
		centerBlock(Vector2(7, 12), 3)
	# 如果有内容的话，则按照如下内容初始化
	else:
		for i in range(13):
			var row1 = []
			for j in range(13):
				row1.append(null)
			BlocksBulidMain.append(row1)
		MapArray = get_parent().SaveMap
		for i in range(13):
			for j in range(13):
				centerBlock(Vector2(i, j), MapArray[i][j])


# 循环的内容
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up1") and $MapBuildMode.position.y > 64:
		$MapBuildMode.position.y -= 64
	if Input.is_action_just_pressed("down1") and $MapBuildMode.position.y < 832:
		$MapBuildMode.position.y += 64
	if Input.is_action_just_pressed("left1") and $MapBuildMode.position.x > 96:
		$MapBuildMode.position.x -= 64
	if Input.is_action_just_pressed("right1") and $MapBuildMode.position.x < 864:
		$MapBuildMode.position.x += 64
	if Input.is_action_just_pressed("b1"):
		if MapArray[($MapBuildMode.position.x - 96) / 64][($MapBuildMode.position.y - 64) / 64] == selectBlock:
			selectBlock -= 1
		buildBlock(Vector2(($MapBuildMode.position.x - 96) / 64, ($MapBuildMode.position.y - 64) / 64))
	if Input.is_action_just_pressed("a1"):
		if MapArray[($MapBuildMode.position.x - 96) / 64][($MapBuildMode.position.y - 64) / 64] == selectBlock:
			selectBlock += 1
		buildBlock(Vector2(($MapBuildMode.position.x - 96) / 64, ($MapBuildMode.position.y - 64) / 64))
	if Input.is_action_just_pressed("start1"):
		get_parent().SaveMap = MapArray
		print(MapArray)
		get_parent().GamePlayerNum = 3
		emit_signal("MapSaveStop")
		await MapSaveStop

# 加载方块的函数
func centerBlock(blockPosition: Vector2, Values: int):
		BlocksBulidMain[blockPosition.x][blockPosition.y] = Blocks.instantiate()
		BlocksBulidMain[blockPosition.x][blockPosition.y].global_position = Vector2(blockPosition.x * 64 + 96, blockPosition.y * 64 + 64)
		BlocksBulidMain[blockPosition.x][blockPosition.y].BuildNum = Values
		MapArray[blockPosition.x][blockPosition.y] = Values
		add_child(BlocksBulidMain[blockPosition.x][blockPosition.y])
# 建造方块的函数
func buildBlock(blockPosition: Vector2):
	# selectBlock是当前选择的方块
	if selectBlock > 13:
		selectBlock = 0
	if selectBlock < 0:
		selectBlock = 13
	# MapArray中对应的位置的值记录下来
	MapArray[blockPosition.x][blockPosition.y] = selectBlock
	# 若BlockBulidMain的当前位置的值为空，则将Block的场景实例化到这个位置
	if BlocksBulidMain[blockPosition.x][blockPosition.y] == null:
		BlocksBulidMain[blockPosition.x][blockPosition.y] = Blocks.instantiate()
		BlocksBulidMain[blockPosition.x][blockPosition.y].global_position = Vector2(blockPosition.x * 64 + 96, blockPosition.y * 64 + 64)
		BlocksBulidMain[blockPosition.x][blockPosition.y].BuildNum = MapArray[blockPosition.x][blockPosition.y]
		add_child(BlocksBulidMain[blockPosition.x][blockPosition.y])
		return
	# 否则不为空，将MapArray的值赋值给BlockBulidMain
	else:
		BlocksBulidMain[blockPosition.x][blockPosition.y].build(MapArray[blockPosition.x][blockPosition.y])
		return

# 负责控制当前坦克闪烁的
func _on_timer_timeout() -> void:
	$MapBuildMode/Sprite2D.visible = !$MapBuildMode/Sprite2D.visible
