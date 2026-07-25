extends Node3D

# Note: this is an export so it can be quickly changed in the inspector. We might want to have a
# quick debug menu which is super quick to start the game (for testing) but also support a proper
# menu
@export var menu_scene: PackedScene

var game_master_scene = preload("res://scenes/game_master.tscn")
var end_screen_scene = preload("res://scenes/end_screen.tscn")

var menu: Node
var end_screen: EndScreen
var current_gm: GameMaster

@onready var state = $StateChart

func _ready() -> void:
	menu = menu_scene.instantiate()
	menu.connect("start_game", _on_menu_start_game)

	end_screen = end_screen_scene.instantiate()
	end_screen.connect("new_game_started", _on_end_screen_new_game_started)

func _on_game_master_game_ended(outcome: GameMaster.GameOutcome) -> void:
	if outcome == GameMaster.GameOutcome.WON:
		state.send_event("win_game")
	else:
		state.send_event("lose_game")

func _on_in_game_state_entered() -> void:
	if current_gm:
		remove_child(current_gm)
		current_gm.queue_free()

	current_gm = game_master_scene.instantiate()
	add_child(current_gm)
	current_gm.connect("game_ended", _on_game_master_game_ended)

func _on_in_game_state_exited() -> void:
	current_gm.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	#  Bit hacky; maybe MouseCaptureController should clean up after itself? But this works
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_initial_menu_state_entered() -> void:
	add_child(menu)

func _on_initial_menu_state_exited() -> void:
	remove_child(menu)

func _on_menu_start_game() -> void:
	state.send_event("start_game")

# Helper function for win/lose states
func show_post_game_screen(won: bool) -> void:
	end_screen.set_text("well done :)" if won else "you lost :()")
	add_child(end_screen)

func _on_won_state_entered() -> void:
	show_post_game_screen(true)

func _on_lost_state_entered() -> void:
	show_post_game_screen(false)

func _on_post_game_state_exited() -> void:
	remove_child(end_screen)

func _on_end_screen_new_game_started() -> void:
	state.send_event("restart")
