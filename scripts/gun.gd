extends Node3D
class_name Gun

@export var player : PlayerController

@export_category("Stats")
@export var max_damage := 2

## An enemy was shot
signal shot_enemy(enemy: Enemy)

func _ready() -> void:
	# Position crosshair in the center of the screen
	# Note: won't respect viewport size changes, but we probably don't want to
	# support changing size mid-game anyway...
	$crosshair.position = get_viewport().size / 2

func fire() -> void:
	var collider = $RayCast3D.get_collider()
	if collider is Enemy:
		player.deal_damage(collider, max_damage)
