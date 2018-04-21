extends Node

func _ready():
	$Player.connect("seeds_changed", $UI/Belt, "update_seeds")
	$Player.connect("belt_cursor_changed", $UI/Belt, "update_cursor")
	$Player.connect("seed_planted", self, "_seed_planted")
	
	# Connect pre-existing item
	for item in $CollectableItems.get_children():
		item.connect("pickup", $Player, "picked_item")
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()

func _seed_planted(seed_type):
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
