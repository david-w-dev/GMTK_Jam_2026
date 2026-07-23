extends CharacterBody3D

@export_group("movement")
@export var movement_speed: int
@export var jump_speed: int
@export var mouse_sensitivity: float

## The player just killed an enemy
signal killed_enemy(enemy: Enemy)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var weapons: Node3D = $Head/weapons
@onready var sword: Sword = get_node("Head/weapons/sword")
@onready var gun: Gun = get_node("Head/weapons/gun")
@onready var head: Node3D = $Head

	
func _input(event):
	# Camera
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -deg_to_rad(70), deg_to_rad(70))

	# Weapons
	if Input.is_action_just_pressed("melee"):
		sword.set_swinging(true)
	if Input.is_action_just_pressed("shoot"):
		gun.fire()

func _physics_process(delta: float) -> void:
	# handle movement
	velocity.y -= gravity * delta
	var input = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = dir.x * movement_speed
	velocity.z = dir.z * movement_speed
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		



func _on_sword_hit_enemy(enemy: Enemy) -> void:
	killed_enemy.emit(enemy)


func _on_gun_shot_enemy(enemy: Enemy) -> void:
	killed_enemy.emit(enemy)
