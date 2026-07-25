extends Node3D
class_name GameMaster

enum RoundOutcome { WON, DIED, TIMEOUT }
signal round_ended(outcome: RoundOutcome)

@export var wall_scene: PackedScene



class Params:
	## The length of each tick in seconds
	var tick_duration_s: float
	## The number of enemies in this round
	var num_enemies: int
	## The round number, to show how many rounds have been played so far (1-indexed)
	var round_number: int


var in_progress = true
var params: Params = null
var num_ticks: int
var ticks_remaining: int
var enemies_remaining: int


func setup(p: Params) -> void:
	params = p
	num_ticks = $Level.get_num_panels()
	ticks_remaining = num_ticks
	enemies_remaining = params.num_enemies


func end_round(outcome: RoundOutcome) -> void:
	if not in_progress:
		# This could happen if multiple enemies hit the player at once, for example
		return
	in_progress = false
	$tick_timer.stop()
	round_ended.emit(outcome)


func _ready() -> void:
	assert(params != null, "GameMaster added with null params")
	# Create walls
	for pos in WallGenerator.get_random_walls():
		var wall = wall_scene.instantiate()
		add_child(wall)
		WallGenerator.set_wall_position(wall, pos)

	set_mock_hud()
	$tick_timer.start(params.tick_duration_s)
	for i in range(params.num_enemies):
		add_child($spawner.spawn_enemy())


func set_mock_hud() -> void:
	# Note: this HUD is just for debug and testing
	$mock_hud.text = "round %d\nticks remaining: %d\nenemies remaining: %d" \
						% [params.round_number, ticks_remaining, enemies_remaining]


func _process(_delta: float) -> void:
	for child in get_children():
		if child is Enemy:
			child.run_towards($player.global_position)


func _on_tick_timer_timeout() -> void:
	$Level.turn_off_panel(num_ticks - ticks_remaining) # 0-indexed
	ticks_remaining -= 1
	set_mock_hud()
	if ticks_remaining == 0:
		end_round(RoundOutcome.TIMEOUT)


func _on_player_death() -> void:
	end_round(RoundOutcome.DIED)


func _on_spawner_enemy_killed() -> void:
	enemies_remaining -= 1
	set_mock_hud()
	if enemies_remaining == 0:
		end_round(RoundOutcome.WON)
