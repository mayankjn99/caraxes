extends GutTest


func test_moving_platform_travels_between_fixed_endpoints_and_repeats() -> void:
	var script: Script = load("res://scripts/moving_platform.gd") as Script
	assert_not_null(script, "Moving platforms should have a reusable motion component.")
	if script == null:
		return

	var platform: Node2D = script.new() as Node2D
	assert_true(platform.has_method("configure_motion"), "Platform motion should be configurable.")
	platform.call("configure_motion", Vector2(100.0, 200.0), Vector2(300.0, 200.0), 2.0)
	assert_eq(platform.position, Vector2(100.0, 200.0), "A platform should start at its configured first endpoint.")
	platform.call("advance_motion", 1.0)
	assert_eq(platform.position, Vector2(200.0, 200.0), "A platform should travel at a predictable constant speed.")
	platform.call("advance_motion", 1.0)
	assert_eq(platform.position, Vector2(300.0, 200.0), "A platform should reach the second endpoint after one travel duration.")
	platform.call("advance_motion", 2.0)
	assert_eq(platform.position, Vector2(100.0, 200.0), "A platform should return to its first endpoint and repeat deterministically.")
	platform.free()


func test_player_rides_moving_platform_and_jumps_off() -> void:
	var script: Script = load("res://scripts/moving_platform.gd") as Script
	assert_not_null(script, "The course should use collidable moving platforms.")
	if script == null:
		return
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	var platform: AnimatableBody2D = script.new() as AnimatableBody2D
	platform.name = "TestMovingPlatform"
	platform.set("platform_size", Vector2(140.0, 24.0))
	platform.call("configure_motion", Vector2(180.0, 350.0), Vector2(380.0, 350.0), 2.0)
	level.add_child(platform)
	player.global_position = Vector2(220.0, 330.0)
	await wait_physics_frames(6)
	assert_true(player.is_on_floor(), "The player should land on the moving platform.")
	var carried_start_x: float = player.global_position.x
	await wait_physics_frames(24)
	assert_gt(player.global_position.x, carried_start_x + 12.0,
		"The player should be carried horizontally while standing on the platform.")
	player.apply_controls(0.0, true)
	assert_lt(player.velocity.y, 0.0, "The player should be able to jump off a moving platform.")
	await wait_physics_frames(1)
	assert_false(player.is_on_floor(), "A jump should separate the player from the moving platform.")
	assert_gt(player.velocity.x, 0.0, "A jump should inherit the moving platform's horizontal momentum.")


func test_passage_one_exit_transitions_without_resetting_the_run() -> void:
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	assert_eq(level.get("current_passage"), 1, "A new run should begin in Passage 1.")
	level.set("run_started", true)
	level.set("elapsed_time", 18.25)
	level.call("complete_level")
	assert_eq(level.get("current_passage"), 2, "The first exit should open Passage 2.")
	assert_false(level.get("completed"), "The first exit should not finish the full run.")
	assert_true(level.get("run_started"), "The run clock should remain active across the passage transition.")
	assert_almost_eq(level.get("elapsed_time"), 18.25, 0.001, "The passage transition should preserve elapsed time.")
	assert_eq(player.position, Vector2(60.0, 430.0), "The player should spawn at the start of Passage 2.")
	assert_false(game.get_node("HUD/Completion").visible, "An intermediate passage should not show final run results.")


func test_stale_passage_one_exit_cannot_finish_passage_two() -> void:
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.set("personal_best", 0.0)
	var passage_one_exit: Area2D = level.get("course_root").get_node("Exit")

	passage_one_exit.body_entered.emit(player)
	level.call("complete_level")
	assert_eq(level.get("current_passage"), 2, "The first exit should transition into Passage 2.")
	await get_tree().process_frame

	assert_false(level.get("completed"), "A stale Passage 1 exit event must not complete the run in Passage 2.")
	assert_false(game.get_node("HUD/Completion").visible,
		"Passage 2 should not display final results before the player reaches its exit.")


func test_entering_passage_one_exit_leaves_passage_two_playable() -> void:
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.global_position = Vector2(900.0, 405.0)
	await wait_physics_frames(3)

	assert_eq(level.get("current_passage"), 2, "Crossing Passage 1's actual exit should load Passage 2.")
	assert_false(level.get("completed"), "Entering Passage 2 should not complete the run.")
	assert_eq(player.global_position, Vector2(60.0, 430.0), "Passage 2 should leave the player at its own spawn.")
	assert_false(game.get_node("HUD/Completion").visible,
		"Passage 2 should remain playable without the final results overlay.")


func test_passage_two_uses_moving_platforms_and_finishes_the_run() -> void:
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	level.set("best_time_path", "res://test/unit/.gut_phase8_final.cfg")
	level.call("complete_level")
	assert_eq(level.get("current_passage"), 2, "The first exit should prepare the second passage.")
	if level.get("current_passage") != 2:
		return
	var moving_platforms: Array[Node] = level.find_children("MovingPlatform*", "AnimatableBody2D", true, false)
	assert_gte(moving_platforms.size(), 2, "Passage 2 should include at least two predictable moving platforms.")
	level.set("run_started", true)
	level.set("elapsed_time", 42.5)
	level.set("personal_best", -1.0)
	level.call("complete_level")
	assert_true(level.get("completed"), "The second exit should finish the complete run.")
	assert_almost_eq(level.get("personal_best"), 42.5, 0.001, "Final completion should record the combined run time.")
	assert_true(game.get_node("HUD/Completion").text.contains("Run complete!"), "Final results should distinguish a complete run from a passage transition.")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("res://test/unit/.gut_phase8_final.cfg"))


func test_fall_in_passage_two_returns_to_its_spawn_and_keeps_run_time() -> void:
	var game: Node = add_child_autofree(load("res://scenes/main.tscn").instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("complete_level")
	player.apply_controls(1.0, false)
	level.call("advance_run_clock", 20.0)
	player.global_position = Vector2(450.0, 651.0)
	level.call("reset_player")
	assert_eq(player.position, Vector2(60.0, 430.0), "A fall in Passage 2 should return to that passage's spawn.")
	assert_true(level.get("run_started"), "A fall in Passage 2 should leave the run clock active.")
	assert_almost_eq(level.get("elapsed_time"), 20.0, 0.001, "A fall in Passage 2 should preserve the full-run time.")
