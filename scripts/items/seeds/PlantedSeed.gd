extends Node2D

signal seed_rewards

const INITIAL_GROWING_STATE = -1

const GRASS_SEEDS = preload("res://scenes/items/seeds/grass/GrassSeed.tscn")
const FLOWER_SEEDS = preload("res://scenes/items/seeds/flower/FlowerSeed.tscn")
const BUSH_SEEDS = preload("res://scenes/items/seeds/bush/BushSeed.tscn")
const TREE_SEEDS = preload("res://scenes/items/seeds/tree/TreeSeed.tscn")

var state = {
	"tick": 0,
	"growing": INITIAL_GROWING_STATE,
	"max_reached": false,
}

export var tick_to_0 = 2
export var tick_to_1 = 5
export var tick_to_2 = 10

func _ready():
	$Tick.connect("timeout", self, "_on_tick")
	# Directly play planted animation
	$AnimationPlanted.play("planted")

const GROWING_STATE = {
	"zero": 0,
	"one": 1,
	"two": 2
}

func _on_tick():
	# Grow seed on tick
	if state.max_reached: return
	
	$Particles.emitting = true
	state.tick += 1
	
	if state.max_reached: return
	
	if state.tick == tick_to_0:
		$GrowingState/Animation.play("grow_to_0")
		state.growing = GROWING_STATE.zero
	elif state.tick == tick_to_1:
		$GrowingState/Animation.play("grow_to_1")
		state.growing = GROWING_STATE.one
	elif state.tick == tick_to_2:
		$GrowingState/Animation.play("grow_to_2")
		state.growing = GROWING_STATE.two
		# Last growing state
		$Tick.queue_free()
		yield($GrowingState/Animation, "animation_finished")
		_on_max_growing()

func _on_max_growing():
	state.max_reached = true
	var rewards = []
	for reward in seed_rewards():
		var current
		match reward:
			"grass":
				current = {"instance": GRASS_SEEDS.instance(), "position": reward_position()}
			"flower":
				current = {"instance": FLOWER_SEEDS.instance(), "position": reward_position()}
			"bush":
				current = {"instance": BUSH_SEEDS.instance(), "position": reward_position()}
			"tree":
				current = {"instance": TREE_SEEDS.instance(), "position": reward_position()}
		rewards.push_back(current)
	
	emit_signal("seed_rewards", rewards)

func reward_position():
	randomize()
	return get_global_position() + Vector2(rand_range(-10, 50), -20)

func seed_rewards():
	return []
