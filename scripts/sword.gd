extends Area3D
class_name Sword

@export var player : PlayerController

@export_category("Stats")
@export var max_damage := 1

@onready var sword_collision := $SwordCollision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_swinging(false)


func set_swinging(should_start: bool) -> void:
	if visible == should_start:
		# Nothing to do
		return
	visible = should_start
	sword_collision.set_deferred("disabled", not should_start)
	if should_start:
		$Timer.start()
	else:
		$Timer.stop()


func _on_timer_timeout() -> void:
	set_swinging(false)


func _on_body_entered(body: Node3D) -> void:
	if visible and body is Enemy:
		var enemy = body
		# TODO: there is a bug where you can hit the same enemy twice in quick succession
		player.deal_damage(enemy, max_damage)
