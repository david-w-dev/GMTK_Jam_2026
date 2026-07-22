extends Node3D

var enemy_scene = preload("res://scenes/enemy.tscn")
@export var spawn_range = 10.0

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
	enemy.global_position = spawn_pos
	add_child(enemy)
