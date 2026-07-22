extends CharacterBody3D

@export_group("movement")
@export var movement_speed: int
@export var jump_speed: int
@export var mouse_sensitivity: float


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func _physics_process(delta: float) -> void:
	# handle movement
	velocity.y -= gravity * delta
	var input = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = dir.x * movement_speed * delta
	velocity.z = dir.z * movement_speed * delta
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		print("jumping")
		velocity.y = jump_speed
