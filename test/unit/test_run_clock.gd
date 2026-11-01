extends GutTest

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")


func test_run_clock_starts_on_first_movement_and_freezes_on_completion() -> void:
	var game: Node = MAIN_SCENE.instantiate()
	game.get_node("Level").set("best_time_path", "user://gut_speedrun_clock.cfg")
	add_child_autofree(game)
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")

	assert_eq(level.get("run_started"), false, "The run clock should wait for movement input.")
	assert_true(player.has_signal("movement_started"), "Player should report the first movement input.")
	assert_true(level.has_method("advance_run_clock"), "Level should expose deterministic clock advancement.")
	if not player.has_signal("movement_started") or not level.has_method("advance_run_clock"):
		return

	player.apply_controls(1.0, false)
	assert_true(level.get("run_started"), "The first movement should start the run clock.")
	level.call("advance_run_clock", 1.25)
	assert_almost_eq(level.get("elapsed_time"), 1.25, 0.001, "The run clock should advance by elapsed frame time.")

	level.set("current_passage", 2)
	level.call("complete_level")
	level.call("advance_run_clock", 2.0)
	assert_almost_eq(level.get("elapsed_time"), 1.25, 0.001, "The run clock should freeze when the level is completed.")


func test_fall_preserves_time_and_explicit_restart_resets_the_run() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.apply_controls(1.0, false)
	level.call("advance_run_clock", 12.5)
	level.call("reset_player")
	assert_almost_eq(level.get("elapsed_time"), 12.5, 0.001, "Falling should preserve the elapsed run time.")
	assert_eq(level.get("run_started"), true, "Falling should leave the current run active.")

	assert_true(level.has_method("restart_run"), "The player should have an explicit run restart action.")
	if not level.has_method("restart_run"):
		return
	level.call("restart_run")
	assert_almost_eq(level.get("elapsed_time"), 0.0, 0.001, "An explicit restart should clear elapsed run time.")
	assert_eq(level.get("run_started"), false, "An explicit restart should wait for the next movement input.")
	player.apply_controls(1.0, false)
	assert_eq(level.get("run_started"), true, "The restarted run should start on its first movement.")


func test_personal_best_persists_and_only_improves() -> void:
	var game: Node = MAIN_SCENE.instantiate()
	game.get_node("Level").set("best_time_path", "user://gut_speedrun_test.cfg")
	add_child_autofree(game)
	var level: Node = game.get_node("Level")
	assert_true(level.has_method("get_personal_best"), "Level should expose the saved personal best.")
	assert_true(level.has_method("record_completed_run"), "Level should record a completed run.")
	if not level.has_method("get_personal_best") or not level.has_method("record_completed_run"):
		return

	level.call("record_completed_run", 42.5)
	assert_almost_eq(level.call("get_personal_best"), 42.5, 0.001, "First completed run should become the personal best.")
	level.call("record_completed_run", 50.0)
	assert_almost_eq(level.call("get_personal_best"), 42.5, 0.001, "A slower run must not replace the best time.")

	var next_game: Node = MAIN_SCENE.instantiate()
	next_game.get_node("Level").set("best_time_path", "user://gut_speedrun_test.cfg")
	add_child_autofree(next_game)
	var next_level: Node = next_game.get_node("Level")
	assert_almost_eq(next_level.call("get_personal_best"), 42.5, 0.001, "Best time should persist between game instances.")


func test_hud_displays_run_time_and_personal_best_on_completion() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var hud: CanvasLayer = game.get_node("HUD")
	var timer_label: Label = hud.get_node("Timer")
	var completion_label: Label = hud.get_node("Completion")
	level.set("elapsed_time", 42.5)
	level.set("current_passage", 2)
	hud.call("_update_timer")
	assert_eq(timer_label.text, "Time: 00:42.50", "HUD should display elapsed run time.")
	level.set("personal_best", 40.0)
	level.call("complete_level")
	assert_true(completion_label.visible, "Completion results should be visible at the exit.")
	assert_true(completion_label.text.contains("Time: 00:42.50"), "Results should include this run's time.")
	assert_true(completion_label.text.contains("Best: 00:40.00"), "Results should include the local best time.")
	var completion_font: Font = completion_label.get_theme_font("font")
	var completion_width: float = completion_font.get_string_size(
		completion_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, completion_label.get_theme_font_size("font_size")
	).x + 32.0
	assert_lte(completion_width, completion_label.size.x,
		"Final time and best results should fit inside the completion panel.")


func test_full_run_and_restart_keep_speedrun_systems_in_sync() -> void:
	var game: Node = MAIN_SCENE.instantiate()
	game.get_node("Level").set("best_time_path", "/tmp/gut_phase11_full_run.cfg")
	game.get_node("AudioManager").set("audio_config_path", "user://gut_phase11_audio.cfg")
	add_child_autofree(game)
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	var hud: CanvasLayer = game.get_node("HUD")
	var audio: Node = game.get_node("AudioManager")

	assert_not_null(level.find_child("DashUnlock", true, false),
		"Passage 1 should expose its marked dash unlock alongside the run HUD.")
	player.apply_controls(1.0, false)
	level.call("advance_run_clock", 10.0)
	assert_true(audio.call("is_music_requested"), "Run music should start with the integrated clock.")
	assert_eq(hud.get_node("Passage").text, "Passage 1 — First ascent")

	level.call("unlock_dash", player)
	level.call("reset_player")
	assert_true(level.get("has_unlocked_dash"), "Fall recovery should preserve the run's dash unlock.")
	assert_true(audio.call("is_music_requested"), "Fall recovery should preserve run music.")
	level.call("complete_level")
	assert_eq(level.get("current_passage"), 2)
	assert_true(level.get("run_started"), "Passage transition should preserve the active run clock.")
	assert_almost_eq(level.get("elapsed_time"), 10.0, 0.001)
	assert_eq(hud.get_node("Passage").text, "Passage 2 — Moving ice")
	assert_gte(level.find_children("MovingPlatform*", "AnimatableBody2D", true, false).size(), 2)
	level.call("advance_run_clock", 7.5)
	level.call("complete_level")
	assert_true(level.get("completed"), "Passage 2's exit should finish the full run.")
	assert_true(hud.get_node("Completion").visible, "Final results should be shown after both passages.")
	assert_true(hud.get_node("Completion").text.contains("Time: 00:17.50"))
	assert_almost_eq(level.get("personal_best"), 17.5, 0.001)
	assert_false(audio.call("is_music_requested"), "Music should stop when the run is complete.")

	level.call("restart_run")
	assert_eq(level.get("current_passage"), 1, "Restart should rebuild Passage 1.")
	assert_eq(player.position, Vector2(80.0, 430.0))
	assert_false(level.get("run_started"), "Restart should wait for first movement before starting the clock.")
	assert_almost_eq(level.get("elapsed_time"), 0.0, 0.001)
	assert_false(level.get("has_unlocked_dash"), "Restart should relock the marked dash ability.")
	assert_false(player.get("dash_unlocked"))
	assert_false(hud.get_node("Completion").visible, "Restart should hide the previous results.")
	assert_eq(hud.get_node("Passage").text, "Passage 1 — First ascent")
	assert_false(audio.call("is_music_requested"), "Restart should stop music until the new run starts.")
	assert_not_null(level.find_child("DashUnlock", true, false), "Restart should restore the dash marker.")
	player.apply_controls(1.0, false)
	assert_true(audio.call("is_music_requested"), "The restarted run should start music with its new clock.")
