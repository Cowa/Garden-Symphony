extends Node

const PLANTED_SEEDS = {
	"grass": preload("res://scenes/items/seeds/grass/PlantedGrass.tscn")
}

func _ready():
	$Player.connect("seeds_changed", $UI/Belt, "update_seeds")
	$Player.connect("belt_cursor_changed", $UI/Belt, "update_cursor")
	$Player.connect("seed_planted", self, "_seed_planted")
	
	# Connect pre-existing item
	for item in $Ground/CollectableItems.get_children():
		item.connect("pickup", $Player, "picked_item")
	
	$Tick.connect("timeout", self, "_on_tick")

func _physics_process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()

func _seed_planted(seed_type, position):
	var seed_instance = PLANTED_SEEDS[seed_type].instance()
	seed_instance.set_position($Ground.to_local(position))
	$Ground/PlantedSeeds.add_child(seed_instance)
	seed_instance.connect("seed_rewards", self, "_on_seed_rewards")

# World ticking
func _on_tick():
	pass

func _on_seed_rewards(rewards):
	for reward in rewards:
		var instance = reward.instance
		instance.set_global_position(reward.position)
		instance.connect("pickup", $Player, "picked_item")
		$Ground/CollectableItems.add_child(instance)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
