extends Node2D

signal seed_rewards

const INITIAL_GROWING_STATE = -1

const GRASS_SEEDS = preload("res://scenes/items/seeds/grass/GrassSeed.tscn")
const FLOWER_SEEDS = preload("res://scenes/items/seeds/flower/FlowerSeed.tscn")
const BUSH_SEEDS = preload("res://scenes/items/seeds/bush/BushSeed.tscn")

var state = {
	"tick": 0,
	"growing": INITIAL_GROWING_STATE,
	"max_reached": false,
}

func _ready():
	$Tick.connect("timeout", self, "_on_tick")
	# Directly play planted animation
	$AnimationPlanted.play("planted")

func _on_tick():
	# Grow seed on tick
	if state.max_reached: return
	
	$Particles.emitting = true
	state.tick += 1

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
		rewards.push_back(current)
	
	emit_signal("seed_rewards", rewards)

func reward_position():
	randomize()
	return get_global_position() + Vector2(rand_range(-10, 50), -20)

func seed_rewards():
	return []

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
