extends RigidBody3D
class_name AmmoPickup

## The speed at which the ammo is projected out of the panels
@export var projection_speed: float

## The energy lost on each bounce (as a proportion of impact speed)
# TODO: use this
@export_range(0.0, 1.0, 0.05) var bounce_dampening: float

func _ready() -> void:
	freeze = true

## Project horizontally outwards from current position in the direction of the
## origin
func project() -> void:
	freeze = false
	var dir = -global_position
	dir.y = 0
	apply_impulse(projection_speed * dir.normalized())
