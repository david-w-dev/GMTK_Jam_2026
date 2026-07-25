extends Node3D
class_name EnemySpawner

var enemy_scene = preload("res://scenes/enemy.tscn")
@export var spawn_max_dist = 20.0 # TODO: better system for this once we have wall generation?
@export var spawn_min_dist = 10.0 # Temporary measure to avoid enemies spawning really close to the player


func spawn_enemy() -> Enemy:
	var angle = randf_range(0, 2 * PI)
	var distance = randf_range(spawn_min_dist, spawn_max_dist)

	var spawn_pos = global_position + distance * Vector3.FORWARD.rotated(Vector3.UP, angle)
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	return enemy
