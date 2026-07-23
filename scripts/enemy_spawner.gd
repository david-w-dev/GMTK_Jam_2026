extends Node3D
class_name EnemySpawner

var enemy_scene = preload("res://scenes/enemy.tscn")
@export var spawn_range = 5.0

func _ready() -> void:
	spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy():
	var random_x = randf_range(-spawn_range, spawn_range)
	var random_z = randf_range(-spawn_range, spawn_range)
	
	var spawn_pos = global_position + Vector3(random_x, 0, random_z)
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_pos
