extends Node3D
class_name Level

func get_num_panels() -> int:
	var count: int = 0
	for child in $PanelBorder.get_children():
		if child is LightPanel:
			count += 1
	return count

func turn_off_panel(idx: int) -> void:
	var panel = $PanelBorder.get_node(PlacePanels.panel_name(idx))
	if panel == null:
		printerr("couldn't get panel %d" % idx)
		return
	panel.switch("off")
