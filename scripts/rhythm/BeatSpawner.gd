extends Node2D

const BEAT = preload("res://scenes/rhythm/Beat.tscn")

export var one_chance_on = 2
export(float) var tick_time = 1

func _ready():
	randomize()
	$Tick.wait_time = tick_time
	$Tick.connect("timeout", self, "_tick")

func _tick():
	if (randi() % one_chance_on == 0):
		var beat = BEAT.instance()
		beat.motion.y = 300
		$Beats.add_child(beat)

func start():
	$Delay.start()
	yield($Delay, "timeout")
	$Delay.stop()
	$Tick.start()

func stop():
	$Tick.stop()
	for beat in $Beats.get_children():
		beat.queue_free()
