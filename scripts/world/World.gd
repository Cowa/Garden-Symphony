extends Node

func _ready():
	# Connect pre-existing item
	for item in $CollectableItems.get_children():
		item.connect("pickup", self, "_player_picked_item")
	pass

func _player_picked_item(item):
	$Player.picked_item(item)

func _physics_process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
