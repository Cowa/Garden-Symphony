extends KinematicBody2D

var motion = Vector2(0, 0)
var pressed = false

func _ready():
	pass

func _physics_process(delta):
	move_and_slide(motion)
