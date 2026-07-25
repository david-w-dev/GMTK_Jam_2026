class_name PlayerController extends CharacterBody3D

@onready var sword: Sword = get_node("Head/weapons/sword")
@onready var gun: Gun = get_node("Head/weapons/gun")

@export_category("Movement")
@export var movement_speed := 5.0
@export var jump_velocity := 5.0
@export var fall_velocity_threshold := -5.0
@export var acceleration := 0.4
@export var deceleration := 0.8
@export_category("References")
@export var camera : CameraController
@export var state_chart : StateChart
@export_category("Effects")
@export var camera_effects : CameraEffects
@export_category("Health")
@export var player_health := 3
@export_category("Weapons")
@export var starting_ammo := 10

# Privates
var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var _current_health : int

var current_fall_velocity : float

## The player deals damage to an enemy
signal damage_enemy(damage_amount : int)

## The player was hit by an enemy
signal death()

func _init() -> void:
	_current_health = player_health

func _input(_event: InputEvent) -> void:
	# Weapons
	if Input.is_action_just_pressed("melee"):
		sword.set_swinging(true)
	if Input.is_action_just_pressed("shoot"):
		gun.fire()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# handle movement
	_input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()

	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * movement_speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)

	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)

	velocity = _movement_velocity

	move_and_slide()

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func jump():
	velocity.y += jump_velocity

func check_fall_speed() -> bool:
	if current_fall_velocity < fall_velocity_threshold:
		current_fall_velocity = 0.0
		return true
	else:
		current_fall_velocity = 0.0
		return false

func take_damage(damage_amount):
	if damage_amount >= _current_health:
		death.emit()
	else:
		_current_health -= damage_amount

func deal_damage(enemy, damage_amount):
	enemy.take_damage(damage_amount)
