extends Area3D
class_name Sword

## The sword just collided with an enemy
signal hit_enemy(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_swinging(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_swinging(should_start: bool) -> void:
	if visible == should_start:
		# Nothing to do
		return
	visible = should_start
	$CollisionShape3D.set_deferred("disabled", not should_start)
	if should_start:
		$Timer.start()
	else:
		$Timer.stop()


func _on_timer_timeout() -> void:
	set_swinging(false)


func _on_body_entered(body: Node3D) -> void:
	if visible and body is Enemy:
		hit_enemy.emit(body)
