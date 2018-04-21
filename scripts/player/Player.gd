extends KinematicBody2D

var motion = Vector2(0, 0)

const GRAVITY = 30
const SPEED = 500
const JUMP = -400
const MAX_FALL_VEL = 400

const UP_DIRECTION = Vector2(0, -1)

######## Callbacks

func _ready():
	pass

func _physics_process(delta):
	motion.y += GRAVITY
	# Cap fall velocity
	motion.y = min(motion.y, MAX_FALL_VEL)
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP
	
	move_and_slide(motion, UP_DIRECTION)

######## Methods

func picked_item(item):
	match item.type:
		"Abstract": print("Player picked abstract item, do nothing.")
		_: print("Unknown item...")
