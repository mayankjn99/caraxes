extends GutTest

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")

var dash_unlock_event_count: int = 0


func test_dash_is_locked_until_the_marked_course_pickup_and_unlocks_once() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	var original_velocity: Vector2 = player.velocity

	assert_true(player.has_method("try_dash"), "Player should expose the dash action for deterministic input tests.")
	assert_false(player.get("dash_unlocked"), "Dash should begin locked.")
	if player.has_method("try_dash"):
		assert_false(player.call("try_dash"), "Dash input should be ignored while locked.")
	assert_eq(player.velocity, original_velocity, "Locked dash input should not change player velocity.")
	var dash_label: Label = game.get_node("HUD/DashStatus")
	assert_lte(_measured_label_width(dash_label, dash_label.text), dash_label.size.x,
		"The locked dash cue should fit on one HUD line.")

	var unlock_marker: Area2D = level.find_child("DashUnlock", true, false) as Area2D
	assert_not_null(unlock_marker, "Passage 1 should contain a clearly marked dash unlock point.")
	assert_true(level.has_method("unlock_dash"), "Level should own the one-time dash unlock event.")
	if unlock_marker == null or not level.has_method("unlock_dash"):
		return

	dash_unlock_event_count = 0
	level.dash_unlocked.connect(_count_dash_unlock_event)
	player.global_position = unlock_marker.global_position
	await wait_physics_frames(2)
	assert_true(player.get("dash_unlocked"), "Touching the course marker should unlock dash automatically.")
	level.call("unlock_dash", player)
	level.call("unlock_dash", player)
	assert_eq(dash_unlock_event_count, 1, "The marker should emit exactly one unlock event.")
	assert_eq(game.get_node("HUD/DashStatus").text, "Dash ready: Shift",
		"The unlock should provide a clear HUD cue and remain unlocked after repeat contact.")
	assert_lte(_measured_label_width(dash_label, dash_label.text), dash_label.size.x,
		"The unlocked dash cue should fit on one HUD line.")


func test_dash_uses_facing_direction_fixed_duration_and_recharge() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	player.apply_controls(-1.0, false)

	assert_true(player.has_method("advance_dash"), "Dash should expose deterministic time advancement for tests.")
	assert_true(player.has_method("is_dashing"), "Player should report whether the dash burst is active.")
	if not player.has_method("advance_dash") or not player.has_method("is_dashing"):
		return

	assert_true(player.call("try_dash"), "Unlocked dash should start when requested.")
	assert_true(player.call("is_dashing"), "The dash should be active during its burst.")
	assert_almost_eq(player.velocity.x, -900.0, 0.001, "Dash should travel in the last horizontal direction at its defined speed.")
	assert_almost_eq(player.velocity.y, 0.0, 0.001, "Dash should hold a horizontal line for its full duration.")
	player.call("advance_dash", 0.17)
	assert_true(player.call("is_dashing"), "The dash should remain active before 0.18 seconds.")
	player.call("advance_dash", 0.01)
	assert_false(player.call("is_dashing"), "The dash should end at 0.18 seconds.")
	assert_false(player.call("try_dash"), "A second dash should be blocked during recharge.")
	player.call("advance_dash", 0.46)
	assert_false(player.call("try_dash"), "Recharge should still be active just before 0.65 seconds from dash start.")
	player.call("advance_dash", 0.01)
	assert_true(player.call("try_dash"), "Dash should recharge after 0.65 seconds.")


func test_dash_remains_unlocked_across_passages_and_stops_on_final_completion() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.set("best_time_path", "res://test/unit/.gut_phase9_final.cfg")
	level.call("unlock_dash", player)
	level.call("complete_level")
	assert_eq(level.get("current_passage"), 2, "The first exit should still transition to Passage 2.")
	assert_true(player.get("dash_unlocked"), "The collected dash should remain available in Passage 2.")
	assert_true(player.call("try_dash"), "The player should be able to dash in Passage 2.")

	level.call("complete_level")
	assert_true(level.get("completed"), "The second exit should finish the run.")
	assert_false(player.call("is_dashing"), "Final completion should cancel an active dash.")
	assert_eq(player.velocity, Vector2.ZERO, "Final completion should stop player movement immediately.")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("res://test/unit/.gut_phase9_final.cfg"))


func test_fall_preserves_dash_unlock_and_recharge_but_restart_locks_it() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	assert_true(player.call("try_dash"), "The unlocked dash should start before the fall.")
	player.call("advance_dash", 0.2)

	level.call("reset_player")
	assert_true(player.get("dash_unlocked"), "A fall should preserve the unlocked ability.")
	assert_false(player.call("try_dash"), "A fall should not bypass remaining dash recharge.")

	level.call("restart_run")
	assert_false(player.get("dash_unlocked"), "A new run should require collecting the unlock again.")
	assert_eq(game.get_node("HUD/DashStatus").text, "Dash locked — find the marker",
		"Restarting should restore the locked dash cue.")


func test_shift_action_starts_dash_after_unlock() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	assert_true(InputMap.has_action("dash"), "The project should define a dedicated dash input action.")
	var shift_is_bound: bool = false
	for event: InputEvent in InputMap.action_get_events("dash"):
		if event is InputEventKey and (event as InputEventKey).physical_keycode == KEY_SHIFT:
			shift_is_bound = true
	assert_true(shift_is_bound, "Shift should be the configured dash key.")
	Input.action_press("dash")
	await wait_physics_frames(1)
	Input.action_release("dash")
	assert_true(player.call("is_dashing"), "Pressing Shift after unlock should trigger the dash burst.")
	game.get_node("HUD").call("_update_dash_status")
	assert_eq(game.get_node("HUD/DashStatus").text, "Dash active", "The HUD should identify an active dash.")
	player.call("advance_dash", 0.18)
	game.get_node("HUD").call("_update_dash_status")
	assert_true(game.get_node("HUD/DashStatus").text.contains("recharging"),
		"The HUD should show that dash is unavailable during recharge.")
	player.call("advance_dash", 0.47)
	game.get_node("HUD").call("_update_dash_status")
	assert_eq(game.get_node("HUD/DashStatus").text, "Dash ready: Shift",
		"The HUD should show dash ready again after recharge.")


func test_air_dash_crosses_passage_two_gap_and_lands_on_the_far_platform() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	level.call("complete_level")
	player.global_position = Vector2(145.0, 280.0)
	player.velocity = Vector2.ZERO
	Input.action_press("move_right")
	assert_true(player.call("try_dash", 1.0), "The unlocked dash should be usable while airborne.")
	await wait_physics_frames(50)
	Input.action_release("move_right")
	assert_eq(level.get("current_passage"), 2, "The dash should remain within Passage 2.")
	assert_gt(player.global_position.x, 390.0, "The dash should carry the player across the moving-platform gap.")
	assert_true(player.is_on_floor(), "Continued movement after the dash should land on the far platform.")
	assert_lt(player.global_position.y, 380.0, "The landing should be on top of the far platform.")


func test_dash_into_passage_one_exit_transitions_without_skipping_passage_two() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	player.global_position = Vector2(870.0, 405.0)
	Input.action_press("move_right")
	assert_true(player.call("try_dash", 1.0), "Dash should be active while approaching the first exit.")
	await wait_physics_frames(3)
	Input.action_release("move_right")
	assert_eq(level.get("current_passage"), 2, "Crossing the first exit during dash should enter Passage 2.")
	assert_false(level.get("completed"), "A dash through Passage 1 must not skip the final passage.")
	assert_lte(player.global_position.x, 75.0, "The transition should reset position to Passage 2's spawn.")


func _count_dash_unlock_event() -> void:
	dash_unlock_event_count += 1


func _measured_label_width(label: Label, text: String) -> float:
	var font: Font = label.get_theme_font("font")
	return font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size")).x + 24.0


func test_dash_collision_with_a_solid_wall_stops_forward_motion() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var player: CharacterBody2D = game.get_node("Level/Player")
	level.call("unlock_dash", player)
	var wall := StaticBody2D.new()
	wall.position = Vector2(330.0, 400.0)
	var wall_collision := CollisionShape2D.new()
	var wall_shape := RectangleShape2D.new()
	wall_shape.size = Vector2(24.0, 160.0)
	wall_collision.shape = wall_shape
	wall.add_child(wall_collision)
	level.add_child(wall)
	player.global_position = Vector2(240.0, 430.0)
	assert_true(player.call("try_dash", 1.0), "Dash should start before reaching the wall.")
	await wait_physics_frames(14)
	assert_lte(player.global_position.x, 306.1, "Dash should collide with the wall instead of passing through it.")
