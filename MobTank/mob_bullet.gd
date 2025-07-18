extends Area2D
@export var custom_class_name = "MobBullet"
@export var SPEED = 240

# 当前的子弹是属于1p还是2p
var thisMobBullet: int = 0
# 子弹等级 并且根据子弹等级提升子弹速度和子弹威力
# 0 1 2 3
var BulletType = 0
# 设一个子弹初始方向（0表示没方向)
var bullet_direction: int = 0
# 用于判断子弹的方向
const UP = 2
const DOWN = 1
const LEFT = 4
const RIGHT = 3
# 定义当前是否处于子弹爆炸状态 false表示否 true表示真
var Explosioning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if bullet_direction == 0:
		print("未获取到子弹的方向")
	initBulletLevel(BulletType)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(bullet_direction, delta)

func initBulletLevel(BLevel):
	if BLevel == 0:
		return
	if BLevel >= 1:
		SPEED += 160
		return

func update_position(direction: int, delta: float) -> void:

	match direction:
		UP:
			rotation_degrees = 0
			position.y -= SPEED * delta
		DOWN:
			rotation_degrees = 180
			position.y += SPEED * delta
		LEFT:
			rotation_degrees = -90
			position.x -= SPEED * delta
		RIGHT:
			rotation_degrees = 90
			position.x += SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_parent().fillBullet(thisMobBullet)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if !Explosioning and area.custom_class_name != "MobTerrainBullet" and area.custom_class_name != "TerrainBullet":
		Explosioning = true
		if area.custom_class_name != "Bullet" and area.custom_class_name != "Shield" :
			get_parent().explotionScene(position)
		SPEED = 0
		get_parent().fillBullet(thisMobBullet)
		queue_free()
