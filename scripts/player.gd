extends CharacterBody3D

@export_group("movement")
@export var movement_speed: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	print(input)
	velocity = Vector3(input.x, input.y, 0) * delta
	move_and_slide()
