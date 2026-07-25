@tool
class_name PlacePanels
extends EditorScript

const RADIUS: float = 22.0
const NUM_PANELS: int = 60

## Get the node name for the panel with index `idx` (0-indexed)
static func panel_name(idx: int) -> String:
	return "panel_%d" % idx

func _run() -> void:
	var scene = EditorInterface.get_edited_scene_root()
	if scene.name != "PanelBorder":
		print("You're editing the wrong scene mate...")
		return

	# Remove all existing panels
	for node in scene.get_children():
		if node is LightPanel:
			scene.remove_child(node)

	var panel_scene = load("res://scenes/light_panel.tscn")
	for i in range(NUM_PANELS):
		var panel = panel_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		panel.name = panel_name(i)
		scene.add_child(panel)
		panel.set_owner(scene)
		var angle: float = 2 * PI * i / NUM_PANELS
		panel.position = RADIUS * Vector3.FORWARD.rotated(Vector3.UP, angle)
		panel.rotation.y = angle
		EditorInterface.mark_scene_as_unsaved()
	print("placed %d panels at radius %f" % [NUM_PANELS, RADIUS])
