extends Node3D
class_name GameMaster

## The length in seconds of each tick (i.e. the time between panels switching off)
@export var tick_duration_secs: float
## The number of enemies in the first round
@export var initial_num_enemies: int
## The number of enemies in a round is the previous number multiplied by this multiplier
## (and rounded). This means that the enemy count grows exponentially over the rounds
@export var num_enemies_multiplier: float

enum GameOutcome { WON, LOST }

signal game_ended(outcome: GameOutcome)

var round_master_scene = preload("res://scenes/round_master.tscn")

@onready var state = $StateChart
var round_index: int = 0
var current_rm: RoundMaster

func _on_pre_round_state_entered() -> void:
	print("in preround")
	# Create a new round
	var params = RoundMaster.Params.new()
	params.round_number = round_index + 1
	params.tick_duration_s = tick_duration_secs
	params.num_enemies = floor(initial_num_enemies * pow(num_enemies_multiplier, round_index))
	params.num_ticks = $Level.get_num_panels()
	params.player = $player
	params.level = $Level
	current_rm = round_master_scene.instantiate()
	current_rm.setup(params)
	current_rm.connect("round_ended", _on_round_ended)

	for i in range(params.num_ticks):
		$Level.switch_panel(i, "on")

	$PreRoundTimer.start()

func _on_post_round_state_entered() -> void:
	print("in postround")
	remove_child(current_rm)
	current_rm.queue_free()
	round_index += 1
	$PostRoundTimer.start()


func _on_pre_round_timer_timeout() -> void:
	state.send_event("start_round")


func _on_during_round_state_entered() -> void:
	add_child(current_rm)

func _on_round_ended(outcome: RoundMaster.RoundOutcome) -> void:
	print("round ended")
	if outcome == RoundMaster.RoundOutcome.WON:
		state.send_event("win_round")
	else:
		game_ended.emit(GameOutcome.LOST)


func _on_post_round_timer_timeout() -> void:
	state.send_event("prepare_for_next_round")
