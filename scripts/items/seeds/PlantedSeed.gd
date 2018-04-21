extends Node2D

const INITIAL_GROWING_STATE = -1

var state = {
	"tick": 0,
	"growing": INITIAL_GROWING_STATE
}

func _ready():
	$Tick.connect("timeout", self, "_on_tick")
	# Directly play planted animation
	$AnimationPlanted.play("planted")

func _on_tick():
	# Grow seed on tick
	state.tick += 1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
