extends Node2D

func _ready():
	pass

func update_seeds(seeds):
	$Grass/count.set_text(render_count(seeds["grass"]))
	$Flower/count.set_text(render_count(seeds["flower"]))
	$Bush/count.set_text(render_count(seeds["bush"]))
	$Tree/count.set_text(render_count(seeds["tree"]))

func render_count(count):
	if count > 99: return "+99"
	else: return str(count)

func update_cursor(belt):
	var selected_item = belt.items[belt.cursor]
	
	match selected_item:
		"guitar": change_cursor_position($Guitar.get_position())
		"grass": change_cursor_position($Grass.get_position())
		"flower": change_cursor_position($Flower.get_position())
		"bush": change_cursor_position($Bush.get_position())
		"tree": change_cursor_position($Tree.get_position())

func change_cursor_position(position):
	position.y += 41
	
	$Cursor/Tween.interpolate_property(
		$Cursor, "position", $Cursor.get_position(), position,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Cursor/Tween.start()

func toggle_guitar_slot():
	$Guitar.show()
