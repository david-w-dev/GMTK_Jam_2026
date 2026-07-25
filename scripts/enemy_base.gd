extends CharacterBody3D
class_name Enemy


@export_group("movement")
@export var movement_speed: int
@export var friction: float = 3
@export_category("Stats")
@export var damage := 1
@export var max_health := 2

@onready var attack_cooldown := $AttackCooldown
@onready var damage_cooldown := $DamageCooldown
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var attack_flag = $AttackFlag
@onready var _current_health := max_health

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var knockback_velocity: Vector3 = Vector3.ZERO

signal death(sender_node : Enemy)

func _ready() -> void:
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.5


func _physics_process(_delta: float) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, friction * _delta * 100)

	if not is_on_floor():
		velocity.y -= gravity * _delta
	else:
		velocity.y = 0

	if nav.is_navigation_finished() or not damage_cooldown.is_stopped():
		velocity.x = knockback_velocity.x
		velocity.z = knockback_velocity.z
		move_and_slide()
		return


	var next_path_position: Vector3 = nav.get_next_path_position()
	next_path_position.y = global_position.y # TODO: maybe this shouldn't be necessary? Need to figure out what's going on with y-coordinates

	var target_velocity = global_position.direction_to(next_path_position) * movement_speed
	velocity.x = target_velocity.x + knockback_velocity.x
	velocity.z = target_velocity.z + knockback_velocity.z

	move_and_slide()
	attack_telegraph()

	# Player collision detection:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var player = collision.get_collider()
		if player is PlayerController:
			deal_damage(player)

func deal_damage(target):
	if attack_cooldown.is_stopped():
		target.take_damage(damage)
		attack_cooldown.start()

func calculate_knockback(source_position: Vector3, force: float):
	var direction = global_position.direction_to(source_position) * -1

	direction.y = 1
	direction = direction.normalized()

	knockback_velocity = direction * force

func take_damage(player_position : Vector3, damage_amount : int, attack_force: float):
	if damage_amount >= _current_health:
		death.emit(self)
	else:
		_current_health -= damage_amount
		damage_cooldown.start()
	calculate_knockback(player_position, attack_force)

func attack_telegraph():
	if not attack_cooldown.is_stopped():
		attack_flag.visible = true
	if attack_cooldown.is_stopped():
		attack_flag.visible = false

func run_towards(point: Vector3) -> void:
	nav.set_target_position(point)
