extends Node3D

## The length in seconds of each tick (i.e. the time between panels switching off)
@export var tick_duration_secs: float
## The number of enemies in the first round
@export var initial_num_enemies: int
## The number of enemies in a round is the previous number multiplied by this multiplier
## (and rounded). This means that the enemy count grows exponentially over the rounds
@export var num_enemies_multiplier: float

# Note: this is an export so it can be quickly changed in the inspector. We might want to have a
# quick debug menu which is super quick to start the game (for testing) but also support a proper
# menu
@export var menu_scene: PackedScene

var game_master_scene = preload("res://scenes/game_master.tscn")
var end_screen_scene = preload("res://scenes/end_screen.tscn")

var menu: Node
var end_screen: EndScreen
var current_gm: GameMaster
var consecutive_rounds_won: int = 0

@onready var state = $StateChart

func _ready() -> void:
	menu = menu_scene.instantiate()
	menu.connect("start_game", _on_menu_start_game)

	end_screen = end_screen_scene.instantiate()
	end_screen.connect("new_game_started", _on_end_screen_new_game_started)

func _on_game_master_round_ended(outcome: GameMaster.RoundOutcome) -> void:
	if outcome == GameMaster.RoundOutcome.WON:
		state.send_event("win_round")
	else:
		state.send_event("lose_round")

func _on_in_round_state_entered() -> void:
	if current_gm:
		remove_child(current_gm)
		current_gm.queue_free()

	var params = GameMaster.Params.new()
	params.round_number = consecutive_rounds_won + 1
	params.tick_duration_s = tick_duration_secs
	params.num_enemies = floor(initial_num_enemies * pow(num_enemies_multiplier, consecutive_rounds_won))

	current_gm = game_master_scene.instantiate()
	current_gm.setup(params)
	add_child(current_gm)
	current_gm.connect("round_ended", _on_game_master_round_ended)

func _on_in_round_state_exited() -> void:
	current_gm.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	#  Bit hacky; maybe MouseCaptureController should clean up after itself? But this works
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_initial_menu_state_entered() -> void:
	add_child(menu)

func _on_initial_menu_state_exited() -> void:
	remove_child(menu)

func _on_menu_start_game() -> void:
	state.send_event("start_round")

# Helper function for win/lose states
func show_post_round(won: bool) -> void:
	var text: String
	if won:
		text = "well done :)"
	else:
		text = "you lost :("
	end_screen.set_text(text)
	add_child(end_screen)

func _on_won_state_entered() -> void:
	consecutive_rounds_won += 1
	show_post_round(true)

func _on_lost_state_entered() -> void:
	consecutive_rounds_won = 0
	show_post_round(false)

func _on_post_round_state_exited() -> void:
	remove_child(end_screen)

func _on_end_screen_new_game_started() -> void:
	state.send_event("restart")
