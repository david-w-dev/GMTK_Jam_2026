extends Node
class_name PanelUtils

const RADIUS: float = 22.0
const NUM_PANELS: int = 60


## Get the node name for the panel with index `idx` (0-indexed)
static func panel_name(idx: int) -> String:
	return "panel_%d" % idx
