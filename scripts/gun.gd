extends Node3D
class_name Gun

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
		shot_enemy.emit(collider)
