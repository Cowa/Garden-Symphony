extends "res://scripts/items/seeds/PlantedSeed.gd"

const GROWING_STATE = {
	"zero": 0,
	"one": 1,
	"two": 2
}

func _ready():
	pass

func _on_tick():
	._on_tick()
	
	if state.tick == 2:
		$GrowingState/Animation.play("grow_to_0")
		state.growing = GROWING_STATE.zero
	elif state.tick == 5:
		$GrowingState/Animation.play("grow_to_1")
		state.growing = GROWING_STATE.one
	elif state.tick == 10:
		$GrowingState/Animation.play("grow_to_2")
		state.growing = GROWING_STATE.two
		# Last growing state
		$Tick.queue_free()
		_on_max_growing()

func seed_rewards():
	randomize()
	
	
	return [
		"grass", "grass"
	]

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
