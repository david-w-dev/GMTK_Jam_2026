extends CharacterBody3D
class_name Enemy


@export_group("movement")
@export var movement_speed: int

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.5


func _physics_process(delta: float) -> void:
	if nav.is_navigation_finished():
		return

	var next_path_position: Vector3 = nav.get_next_path_position()
	next_path_position.y = global_position.y # TODO: maybe this shouldn't be necessary? Need to figure out what's going on with y-coordinates
	velocity = global_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func run_towards(point: Vector3) -> void:
	nav.set_target_position(point)
