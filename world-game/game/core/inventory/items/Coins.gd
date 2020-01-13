tool
extends Area2D

enum COIN_AMOUNTS {SMALL=10, MID=30, HIGH=100}

export(COIN_AMOUNTS) var amount = COIN_AMOUNTS.SMALL setget set_amount
export(float) var MAX_START_VERTICAL_THRUST = 400.0
export(float) var MAX_HORIZONTAL_SPEED = 200.0
export(float) var GRAVITY = 2000.0
export(float) var STOP_THRESHOLD_VERTICAL_SPEED = 4.0
export(float, 0.0, 1.0) var DAMPING_FACTOR = 0.4

onready var sprite = $coins

var direction = Vector2()
var velocity = Vector2()
var speed_horizontal = 0.0
var speed_vertical = 0.0
var height = 0.0 setget set_height

const TEXTURES = { 
	COIN_AMOUNTS.SMALL: preload("res://game/core/inventory/items/coins/coin_single.png"),
	COIN_AMOUNTS.MID: preload("res://game/core/inventory/items/coins/coins_three.png"),
	COIN_AMOUNTS.HIGH: preload("res://game/core/inventory/items/coins/coins_stack.png") 
}

func set_amount(value):
	amount = value
	if not sprite:
		return
	
	sprite.texture = TEXTURES[value]

func _ready():
	set_process(false)

func throw():
	var rand_angle = randf() * 2 * PI
	direction = Vector2(
		cos(rand_angle),
		sin(rand_angle))
	speed_vertical = (randf() * 0.5 + 0.5) * MAX_START_VERTICAL_THRUST
	speed_horizontal = (randf() * 0.8 + 0.2) * MAX_HORIZONTAL_SPEED
	$Timer.wait_time = rand_range(1.0, 2.0)
	$Timer.start()
	set_process(true)

func _process(delta):
	# Move horizontally
	var speed_scale = $Timer.time_left / $Timer.wait_time
	velocity = speed_horizontal * direction * speed_scale
	position += velocity * delta

	# Move vertically
	speed_vertical -= GRAVITY * delta
	var distance_vertical = speed_vertical * delta
	self.height += distance_vertical
	if height < 0.0:
		self.height = 0.0
		set_process(false)

func set_height(value):
	height = value
	if is_processing():
		$coins.position.y = -height

func set_random_amount():
	var amounts = [COIN_AMOUNTS.SMALL, COIN_AMOUNTS.MID, COIN_AMOUNTS.HIGH]
	self.amount = amounts[randi() % amounts.size()]

# TODO: won't work as currently velocity is re-calculated on every process tick
#func steer_towards(target_global_position):
#	velocity = Steering.follow(
#		velocity, 
#		global_position, 
#		target_global_position, 
#		MAX_HORIZONTAL_SPEED)
