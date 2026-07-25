extends Node3D
class_name EnemySpawner

var enemy_scene = preload("res://scenes/enemy.tscn")
@export var spawn_max_dist = 20.0 # TODO: better system for this once we have wall generation?
@export var spawn_min_dist = 10.0 # Temporary measure to avoid enemies spawning really close to the player

signal enemy_killed()


func spawn_enemy() -> Enemy:
	var angle = randf_range(0, 2 * PI)
	var distance = randf_range(spawn_min_dist, spawn_max_dist)
	var spawn_pos = global_position + distance * Vector3.FORWARD.rotated(Vector3.UP, angle)

	var enemy = enemy_scene.instantiate()
	enemy.death.connect(_on_enemy_death)
	enemy.global_position = spawn_pos
	return enemy

func _on_enemy_death(enemy):
	enemy_killed.emit()
	enemy.queue_free()
