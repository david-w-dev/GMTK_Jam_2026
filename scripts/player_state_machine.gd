class_name PlayerStateMachine extends Node

@export_category("References")
@export var player_controller : PlayerController




func _on_idle_state_physics_processing(_delta: float) -> void:
	if player_controller and player_controller._input_dir.length() > 0:
		player_controller.state_chart.send_event("onMoving")


func _on_moving_state_physics_processing(_delta: float) -> void:
	if player_controller._input_dir.length() == 0 and player_controller.velocity.length() < 0.5:
		player_controller.state_chart.send_event("onIdle")


func _on_grounded_state_physics_processing(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player_controller.is_on_floor():
		player_controller.jump()
		player_controller.state_chart.send_event("onAirborne")

	if not player_controller.is_on_floor():
		player_controller.state_chart.send_event("onAirborne")

func _on_airborne_state_physics_processing(_delta: float) -> void:
	if player_controller.is_on_floor():
		if player_controller.check_fall_speed():
			player_controller.camera_effects.add_fall_kick(2.0)
		player_controller.state_chart.send_event("onGrounded")

	player_controller.current_fall_velocity = player_controller.velocity.y
