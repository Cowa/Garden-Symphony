extends Node2D

var state = {
	"growing": 0
}

func _ready():
	$Tick.connect("timeout", self, "_on_tick")

func _on_tick():
	# Grow seed on tick
	state.growing += 1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
