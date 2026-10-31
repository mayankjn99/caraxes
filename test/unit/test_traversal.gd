extends GutTest

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")


func test_player_moves_and_jumps_from_ground() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	await wait_physics_frames(2)
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.apply_controls(1.0, false)
	assert_gt(player.velocity.x, 0.0, "Right input should move the player right.")
	player.apply_controls(-1.0, false)
	assert_lt(player.velocity.x, 0.0, "Left input should move the player left.")
	player.apply_controls(0.0, true)
	assert_lt(player.velocity.y, 0.0, "Jump input while grounded should launch upward.")


func test_player_does_not_jump_while_airborne() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.velocity.y = -40.0
	player.apply_controls(0.0, true)
	assert_eq(player.velocity.y, -40.0, "Airborne jump input should not reset vertical velocity.")


func test_player_lands_on_platform_and_cannot_fall_through() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	await wait_physics_frames(45)
	var player: CharacterBody2D = game.get_node("Level/Player")
	assert_true(player.is_on_floor(), "The player should be supported by the first platform.")
	assert_almost_eq(player.global_position.y, 431.0, 2.0, "The player should settle on top of the platform.")


func test_falling_below_level_restarts_player() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	await wait_physics_frames(2)
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.global_position = Vector2(250.0, 651.0)
	await wait_physics_frames(1)
	assert_almost_eq(player.position.x, 80.0, 0.1, "A fall reset should restore the spawn x position.")
	assert_almost_eq(player.position.y, 430.0, 0.5, "A fall reset should restore the spawn y position.")


func test_fall_resets_player_to_start() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.position = Vector2(250, 900)
	game.get_node("Level").reset_player()
	assert_eq(player.position, Vector2(80, 430), "A fall reset should restore the starting position.")
	assert_eq(player.velocity, Vector2.ZERO, "A fall reset should clear velocity.")


func test_exit_changes_game_to_completed_state() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	game.get_node("Level").complete_level()
	assert_true(game.get_node("HUD/Completion").visible, "Completion should be clearly visible.")


func test_touching_exit_completes_level() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var player: CharacterBody2D = game.get_node("Level/Player")
	player.global_position = Vector2(900.0, 405.0)
	await wait_physics_frames(2)
	assert_true(game.get_node("Level").completed, "Entering the exit should complete the level.")
	assert_true(game.get_node("HUD/Completion").visible, "Entering the exit should show completion feedback.")


func test_fall_reset_clears_completion_feedback() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	level.complete_level()
	level.reset_player()
	assert_false(game.get_node("HUD/Completion").visible, "Restarting should clear completion feedback.")
