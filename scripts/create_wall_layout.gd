## Temporary script to play around with wall generation
##
## This will move into the actual game when it's good enough...
@tool
class_name CreateWallLayout
extends EditorScript

## The radius of the circle which bounds all walls, as a proportion of the panel
## circle
const WALL_CIRCLE_SIZE: float = 0.75

## The width of the wall scene in 3D space
const WALL_MODEL_WIDTH: float = 4.0

## The desired width of the walls in 3D space as they  will appear to the player.
## The wall scene is scaled to meet this size. Together with the panel circle
## radius, this determines the grid size
const WALL_TARGET_WIDTH: float = 4.0

## The width/height of the square grid in cells
## Conceptually this grid extends so that it circumscribes the panel cirlce
const GRID_SIZE_CELLS: int = 2 * PlacePanels.RADIUS / WALL_TARGET_WIDTH

enum Orientation { NORTH_SOUTH, EAST_WEST } # -ve z is north, +ve x is east
enum Direction { NORTH, EAST, SOUTH, WEST }

## A wall position (i.e. a space where a wall could be placed) is a barrier between two cells.
## We can represent positions uniquely by specifying the most north-westernly of the two cells and
## the orientation of the wall
class WallPosition:
	## The grid coords of the NW-most cell (where (0, 0) is the NW corner)
	var cell: Vector2i
	## The orientation of the wall
	var orientation: Orientation
	## The height of the wall (as a proportion of maximum height)
	var height: float

	func _init(c, o, h):
		cell = c
		orientation = o
		height = h

# Set grid size so that it circumscribes the circle on which panels lie.
# Note that this assumes the panel border scene matches the current version of the panel
# placement script.
const SIDE_LENGTH: float = 2 * PlacePanels.RADIUS
const NW_CORNER: Vector2 = Vector2(-SIDE_LENGTH / 2, -SIDE_LENGTH / 2)
const CELL_SIZE: float = SIDE_LENGTH / GRID_SIZE_CELLS
const SCALE: float = CELL_SIZE / WALL_MODEL_WIDTH
var wall_scene = load("res://scenes/wall.tscn")

static func get_random_walls() -> Array[WallPosition]:
	var wall_positions: Array[WallPosition] = []
	var center_cell = Vector2(GRID_SIZE_CELLS / 2, GRID_SIZE_CELLS / 2)
	for x in range(GRID_SIZE_CELLS):
		for y in range(GRID_SIZE_CELLS):
			var cell = Vector2(x, y)
			var orientations = []
			if y + 1 < GRID_SIZE_CELLS:
				orientations.append(Orientation.EAST_WEST)
			if x + 1 < GRID_SIZE_CELLS:
				orientations.append(Orientation.NORTH_SOUTH)
			for o in orientations:
				# Skip if the wall center is outside the wall circle
				var offset = Vector2(0.5, 0) if o == Orientation.NORTH_SOUTH \
							 else Vector2(0, 0.5)
				var dist_to_center = (Vector2(cell) + offset - center_cell).length()
				if  dist_to_center / (0.5 * GRID_SIZE_CELLS) > WALL_CIRCLE_SIZE:
					continue
				if randf() < 0.3:
					var h = 0.3 if randf() < 0.5 else 1.0
					wall_positions.append(WallPosition.new(cell, o, h))
	return wall_positions

static func set_wall_position(wall: Node, pos: WallPosition) -> void:
	var offset = Vector2(CELL_SIZE / 2, 0) if pos.orientation == Orientation.NORTH_SOUTH \
				 else Vector2(0, CELL_SIZE / 2)
	var pos2d = NW_CORNER + CELL_SIZE * (Vector2(pos.cell) + Vector2(0.5, 0.5)) + offset
	wall.position = Vector3(pos2d.x, 0, pos2d.y)
	wall.scale.x = SCALE
	wall.scale.y = pos.height
	wall.rotation.y = PI / 2 if pos.orientation == Orientation.NORTH_SOUTH else 0

func _run() -> void:
	var scene = EditorInterface.get_edited_scene_root()
	if scene.name != "Walls":
		print("You're editing the wrong scene mate...")
		return
	print("grid size is %d" % GRID_SIZE_CELLS)
	# Remove all existing children
	for node in scene.get_children():
		scene.remove_child(node)
	# Place walls
	var positions = get_random_walls()
	for p in positions:
		var wall = wall_scene.instantiate()
		scene.add_child(wall)
		wall.set_owner(scene)
		set_wall_position(wall, p)
	print("created %d walls" % positions.size())
