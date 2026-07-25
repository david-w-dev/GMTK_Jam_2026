extends Node3D
class_name LightPanel

@onready var on = $StaticBody3D/panel_on
@onready var off = $StaticBody3D/panel_off
@onready var dim = $StaticBody3D/panel_dim

@onready var options : Dictionary = {
	"on": on,
	"off" : off,
	"dim" : dim,
		}

## Pass a string option listed above. Ez.
func switch(option : String):
	for key in options:
		options[key].visible = (key == option)
