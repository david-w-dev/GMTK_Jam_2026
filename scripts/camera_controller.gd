class_name CameraController extends Node3D

@export_category("References")
@export var player_controller : PlayerController
@export var component_mouse_capture : MouseCaptureComponent

@export_category("Camera Settings")
@export_group("Camera Tilt")
@export_range(-90, -60) var tilt_lower_limit := -70
@export_range(60, 90) var tilt_upper_limit := 70

var _rotation : Vector3

func _process(_delta: float) -> void:
	update_camera_rotation(component_mouse_capture._mouse_input)

func update_camera_rotation(input: Vector2):
	_rotation.x += input.y
	_rotation.y += input.x
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))

	var _camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	var _player_rotation = Vector3(0.0, _rotation.y, 0.0)

	transform.basis = Basis.from_euler(_camera_rotation)
	player_controller.update_rotation(_player_rotation)

	rotation.z = 0.0
