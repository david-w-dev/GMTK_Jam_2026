extends Node3D
class_name Level

func get_num_panels() -> int:
	var count: int = 0
	for child in $PanelBorder.get_children():
		if child is LightPanel:
			count += 1
	return count

func switch_panel(idx: int, state: String) -> void:
	var panel = $PanelBorder.get_node(PanelUtils.panel_name(idx))
	if panel == null:
		printerr("couldn't get panel %d" % idx)
		return
	panel.switch(state)
