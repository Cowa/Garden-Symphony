extends KinematicBody2D

# Signal

signal seeds_changed
signal seed_planted
signal belt_cursor_changed

# Constant stuff

const GRAVITY = 30
const SPEED = 250
const JUMP = -400
const MAX_FALL_VEL = 400
const LEFT_DIRECTION = Vector2(-1, 0)
const RIGHT_DIRECTION = Vector2(1, 0)

const UP_DIRECTION = Vector2(0, -1)

# Motion and state

var motion = Vector2(0, 0)
var facing = RIGHT_DIRECTION

var state = {
	"seeds": {
		"grass": 0,
		"flower": 0,
		"tree": 0,
		"bush": 0
	},
	"belt": {
		"cursor": 0,
		"items": ["guitar", "grass", "flower", "bush", "tree"]
	}
}

######## Callbacks

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		facing = RIGHT_DIRECTION
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		facing = LEFT_DIRECTION
	else:
		motion.x = 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP
	
	# Manage change belt cursor
	if Input.is_action_pressed("left_belt_cursor"):
		belt_cursor_to_left()
	elif Input.is_action_pressed("right_belt_cursor"):
		belt_cursor_to_right()
	
	# Plant seeds! (if we can)
	if can_plant() and Input.is_action_just_pressed("plant_seed"):
		plant_seed()

func _physics_process(delta):
	# Movements
	motion.y += GRAVITY
	# Cap fall velocity
	motion.y = min(motion.y, MAX_FALL_VEL)
	move_and_slide(motion, UP_DIRECTION)
	
	# Plant indicator
	process_plant_indicator()

######## Methods

func picked_item(item):
	match item.type:
		"Abstract": print("Picked abstract item, do nothing.")
		"Seed": picked_seed(item)
		_: print("Unknown item...")
	pass

# seed is a keyword cannot use it
func picked_seed(seed_):
	match seed_.seed_type:
		"Grass": picked_grass_seed(seed_)
		"Abstract": print("Picked abstract seed, do nothing")
		_: print("Unknown seed...")

func picked_grass_seed(grass_seed):
	increment_seed("grass")

# Increment nb of `type` seed in inventory
func increment_seed(type):
	state["seeds"][type] += 1
	emit_signal("seeds_changed", state["seeds"])

# Decrement nb of `type` seed in inventory
func decrement_seed(type):
	state["seeds"][type] -= 1
	emit_signal("seeds_changed", state["seeds"])

func belt_cursor_to_left():
	if state.belt.cursor == 0:
		change_belt_cursor(state.belt.items.size() - 1)
	else:
		change_belt_cursor(state.belt.cursor - 1)

func belt_cursor_to_right():
	if state.belt.cursor == state.belt.items.size() - 1:
		change_belt_cursor(0)
	else:
		change_belt_cursor(state.belt.cursor + 1)

func change_belt_cursor(new_cursor):
	state.belt.cursor = new_cursor
	emit_signal("belt_cursor_changed", state.belt)

func process_plant_indicator():
	# Manage plant indicator position based on facing
	if (facing == RIGHT_DIRECTION):
		$PlantIndicator/Sprite.set_position($PlantIndicator/RightPosition.get_position())
	else:
		$PlantIndicator/Sprite.set_position($PlantIndicator/LeftPosition.get_position())
	
	# Should we show it?
	if can_plant(): $PlantIndicator.show()
	else: $PlantIndicator.hide()

# Whether or not we can plant a seed in our current state
func can_plant():
	var selected_item = state.belt.items[state.belt.cursor]
	var must_show = (selected_item in ["grass", "flower", "tree", "bush"] and state.seeds[selected_item] > 0)
	return must_show and is_on_floor()

func plant_seed():
	var seed_type = state.belt.items[state.belt.cursor]
	decrement_seed(seed_type)
	emit_signal("seed_planted", seed_type, $PlantIndicator/Sprite.get_global_position())
