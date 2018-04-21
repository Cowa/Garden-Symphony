extends Node2D

signal pickup

export var type = "Abstract"

func _ready():
	$Area.connect("body_entered", self, "_on_body_entered")
	$Tween.connect("tween_completed", self, "_on_snapped_to_player")

func _on_body_entered(body):
	if body.name == "Player":
		float_to_player(body)

func _on_snapped_to_player(object, key):
	$Pickup.play()
	emit_signal("pickup", self)
	
	# Wait sound to finished
	yield($Pickup, "finished")
	queue_free()

func float_to_player(player):
	$Tween.follow_property(
		self, "position", get_position(),
		player.get_node("Belt"), "global_position",
		0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()
