extends Node3D

@onready var spawner: EnemySpawner = get_node("Enemy Spawner")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy = spawner.get_child(0) # TODO: just a hack for now
	if enemy is Enemy:
		enemy.run_towards($player.global_position)
	else:
		print("child of spawner is not an enemy...")


func _on_player_killed_enemy(enemy: Enemy) -> void:
	spawner.remove_child(enemy)
	spawner.spawn_enemy()
