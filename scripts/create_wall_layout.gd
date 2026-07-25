## Temporary script to play around with wall generation
@tool
class_name CreateWallLayout
extends EditorScript

var wall_scene = preload("res://scenes/wall.tscn")

func _run() -> void:
	var scene = EditorInterface.get_edited_scene_root()
	if scene.name != "Walls":
		print("You're editing the wrong scene mate...")
		return
	print("grid size is %d" % WallGenerator.GRID_SIZE_CELLS)
	# Remove all existing children
	for node in scene.get_children():
		scene.remove_child(node)
	# Place walls
	var positions = WallGenerator.get_random_walls()
	for p in positions:
		var wall = wall_scene.instantiate()
		scene.add_child(wall)
		wall.set_owner(scene)
		WallGenerator.set_wall_position(wall, p)
	print("created %d walls" % positions.size())
