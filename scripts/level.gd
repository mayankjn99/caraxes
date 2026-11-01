extends Node2D

signal level_completed
signal level_restarted
signal run_began
signal run_restarted
signal passage_changed(passage_number: int)
signal dash_unlocked

const PLAYER_START := Vector2(80.0, 430.0)
const BEST_TIME_PATH := "user://speedrun.cfg"
const MOVING_PLATFORM_SCRIPT: Script = preload("res://scripts/moving_platform.gd")
var best_time_path: String = BEST_TIME_PATH
const PLATFORM_TOPS: Array[Rect2] = [
	Rect2(0.0, 450.0, 300.0, 90.0),
	Rect2(380.0, 420.0, 180.0, 120.0),
	Rect2(630.0, 375.0, 130.0, 165.0),
	Rect2(800.0, 450.0, 160.0, 90.0),
]
const PASSAGE_TWO_STATIC_TOPS: Array[Rect2] = [
	Rect2(0.0, 450.0, 160.0, 90.0),
	Rect2(390.0, 380.0, 150.0, 160.0),
	Rect2(790.0, 450.0, 170.0, 90.0),
]

var completed: bool = false
var player: CharacterBody2D
var course_root: Node2D
var current_passage: int = 1
var current_spawn: Vector2 = PLAYER_START
var run_started: bool = false
var elapsed_time: float = 0.0
var personal_best: float = -1.0
var has_unlocked_dash: bool = false
var exit_completion_pending: bool = false
var course_generation: int = 0


func _ready() -> void:
	player = $Player
	personal_best = get_personal_best()
	player.movement_started.connect(start_run)
	course_root = Node2D.new()
	course_root.name = "Course"
	add_child(course_root)
	_build_passage_one()
	queue_redraw()


func _process(delta: float) -> void:
	advance_run_clock(delta)
	if Input.is_action_just_pressed("restart"):
		restart_run()
	if not completed and player.global_position.y > 650.0:
		reset_player()


func start_run() -> void:
	if completed or run_started:
		return
	run_started = true
	run_began.emit()


func advance_run_clock(delta: float) -> void:
	if run_started and not completed:
		elapsed_time += delta


func reset_player() -> void:
	completed = false
	player.reset_to(current_spawn)
	level_restarted.emit()


func restart_run() -> void:
	completed = false
	current_passage = 1
	current_spawn = PLAYER_START
	run_started = false
	elapsed_time = 0.0
	has_unlocked_dash = false
	player.lock_dash()
	player.reset_to(PLAYER_START, true)
	_build_passage_one()
	passage_changed.emit(current_passage)
	level_restarted.emit()
	run_restarted.emit()


func complete_level() -> void:
	if completed:
		return
	if current_passage == 1:
		_enter_passage_two()
		return
	completed = true
	player.stop_for_completion()
	record_completed_run(elapsed_time)
	level_completed.emit()


func get_personal_best() -> float:
	if personal_best >= 0.0:
		return personal_best
	var config := ConfigFile.new()
	if config.load(best_time_path) != OK:
		return -1.0
	return config.get_value("speedrun", "personal_best", -1.0)


func record_completed_run(run_time: float) -> void:
	if run_time < 0.0:
		return
	var best := get_personal_best()
	if best >= 0.0 and best <= run_time:
		personal_best = best
		return
	personal_best = run_time
	var config := ConfigFile.new()
	config.set_value("speedrun", "personal_best", run_time)
	var absolute_path := ProjectSettings.globalize_path(best_time_path)
	var directory_error := DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	if directory_error != OK and directory_error != ERR_ALREADY_EXISTS:
		push_error("Could not create personal-best directory: %s" % error_string(directory_error))
		return
	var save_error: Error = config.save(best_time_path)
	if save_error != OK:
		push_error("Could not save personal best to %s: %s" % [best_time_path, error_string(save_error)])


func _enter_passage_two() -> void:
	current_passage = 2
	current_spawn = Vector2(60.0, 430.0)
	completed = false
	player.controls_enabled = true
	_build_passage_two()
	player.reset_to(current_spawn)
	passage_changed.emit(current_passage)
	level_restarted.emit()
	queue_redraw()


func _build_passage_one() -> void:
	_clear_course()
	for platform: Rect2 in PLATFORM_TOPS:
		_add_platform(platform)
	_add_dash_unlock()
	_add_goal(Vector2(900.0, 405.0))
	queue_redraw()


func _build_passage_two() -> void:
	_clear_course()
	for platform: Rect2 in PASSAGE_TWO_STATIC_TOPS:
		_add_platform(platform)
	_add_moving_platform(Vector2(210.0, 410.0), Vector2(340.0, 410.0), 2.6,
			Vector2(112.0, 24.0), "MovingPlatform_Horizontal")
	_add_moving_platform(Vector2(625.0, 345.0), Vector2(625.0, 410.0), 2.0,
			Vector2(112.0, 24.0), "MovingPlatform_Vertical")
	_add_goal(Vector2(900.0, 405.0))
	queue_redraw()


func _clear_course() -> void:
	course_generation += 1
	exit_completion_pending = false
	for child: Node in course_root.get_children():
		child.queue_free()


func _add_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.position + rect.size * 0.5
	body.name = "Platform_%d" % course_root.get_child_count()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	body.add_child(collision)
	course_root.add_child(body)


func _add_moving_platform(start_position: Vector2, end_position: Vector2, travel_duration: float,
		platform_size: Vector2, platform_name: String) -> void:
	var platform := MOVING_PLATFORM_SCRIPT.new() as AnimatableBody2D
	platform.name = platform_name
	platform.set("platform_size", platform_size)
	platform.call("configure_motion", start_position, end_position, travel_duration)
	course_root.add_child(platform)


func _add_goal(goal_position: Vector2) -> void:
	var goal := Area2D.new()
	goal.name = "Exit"
	goal.position = goal_position
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(36.0, 90.0)
	collision.shape = shape
	goal.add_child(collision)
	goal.body_entered.connect(_on_exit_body_entered.bind(course_generation, goal))
	course_root.add_child(goal)


func _add_dash_unlock() -> void:
	var pickup := Area2D.new()
	pickup.name = "DashUnlock"
	pickup.position = Vector2(520.0, 390.0)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(40.0, 64.0)
	collision.shape = shape
	pickup.add_child(collision)
	pickup.body_entered.connect(unlock_dash)
	course_root.add_child(pickup)


func unlock_dash(body: Node2D) -> void:
	if body != player or has_unlocked_dash:
		return
	has_unlocked_dash = true
	player.unlock_dash()
	dash_unlocked.emit()
	queue_redraw()


func _on_exit_body_entered(body: Node2D, generation: int, exit_area: Area2D) -> void:
	if body != player or generation != course_generation or exit_completion_pending:
		return
	exit_completion_pending = true
	call_deferred("_complete_level_from_exit", generation, exit_area)


func _complete_level_from_exit(generation: int, exit_area: Area2D) -> void:
	if generation != course_generation or not is_instance_valid(exit_area):
		return
	exit_completion_pending = false
	if not exit_area.overlaps_body(player):
		return
	complete_level()


func _draw() -> void:
	# A restrained, hand-drawn winter palette keeps the level self-contained.
	draw_rect(Rect2(0.0, 0.0, 960.0, 540.0), Color("#b9dce5"))
	draw_rect(Rect2(0.0, 0.0, 960.0, 205.0), Color("#d7edf0"))
	# Distant snowy ridges.
	draw_colored_polygon(PackedVector2Array([
		Vector2(0, 260), Vector2(115, 128), Vector2(206, 236), Vector2(320, 108),
		Vector2(448, 248), Vector2(575, 144), Vector2(700, 250), Vector2(825, 120),
		Vector2(960, 252), Vector2(960, 540), Vector2(0, 540),
	]), Color("#a8cbd5"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0, 320), Vector2(155, 210), Vector2(282, 316), Vector2(430, 204),
		Vector2(580, 325), Vector2(748, 214), Vector2(960, 326), Vector2(960, 540), Vector2(0, 540),
	]), Color("#c6e1e5"))
	# Snow caps give the ridges a readable silhouette.
	for peak: Vector2 in [Vector2(115, 128), Vector2(320, 108), Vector2(575, 144), Vector2(825, 120)]:
		draw_colored_polygon(PackedVector2Array([
		peak, peak + Vector2(-24, 28), peak + Vector2(0, 19), peak + Vector2(25, 31),
	]), Color("#f4fbf8"))
	draw_circle(Vector2(760.0, 100.0), 35.0, Color("#f7fcf5"))
	draw_circle(Vector2(760.0, 100.0), 27.0, Color("#fffef1"))
	# Sparse snow glints in the open sky.
	for flake: Vector2 in [Vector2(64, 82), Vector2(186, 62), Vector2(463, 90), Vector2(656, 52), Vector2(893, 78)]:
		draw_circle(flake, 2.0, Color("#f5fbfa"))
	if current_passage == 1 and not has_unlocked_dash:
		draw_circle(Vector2(520.0, 388.0), 25.0, Color("#f0c783", 0.3))
		draw_colored_polygon(PackedVector2Array([
			Vector2(520, 361), Vector2(536, 388), Vector2(520, 415), Vector2(504, 388),
		]), Color("#f0c783"))
		draw_string(ThemeDB.fallback_font, Vector2(500, 352), "DASH", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#31566a"))
	var platform_tops: Array[Rect2] = PLATFORM_TOPS if current_passage == 1 else PASSAGE_TWO_STATIC_TOPS
	for rect: Rect2 in platform_tops:
		_draw_ice_platform(rect)
	# Warm lantern marker makes the goal easy to spot against the cold palette.
	draw_circle(Vector2(900, 378), 27, Color("#e6a961", 0.22))
	draw_rect(Rect2(886.0, 355.0, 28.0, 52.0), Color("#b86f4c"))
	draw_rect(Rect2(882.0, 351.0, 36.0, 8.0), Color("#f0c783"))
	draw_rect(Rect2(892.0, 366.0, 16.0, 16.0), Color("#fff2bd"))
	draw_rect(Rect2(895.0, 369.0, 10.0, 10.0), Color("#fffbe0"))


func _draw_ice_platform(rect: Rect2) -> void:
	var base := Rect2(rect.position.x, rect.position.y + 8.0, rect.size.x, rect.size.y - 8.0)
	draw_rect(base, Color("#769eae"))
	draw_rect(Rect2(rect.position.x, rect.position.y + 8.0, rect.size.x, 8.0), Color("#a5c8d2"))
	draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, 10.0), Color("#f3fbf7"))
	draw_line(Vector2(rect.position.x + 8, rect.position.y + 12), Vector2(rect.end.x - 8, rect.position.y + 12), Color("#ffffff"), 2.0)
	for x: float in range(int(rect.position.x + 18), int(rect.end.x - 8), 44):
		draw_line(Vector2(x, rect.position.y + 25), Vector2(x + 8, rect.position.y + 36), Color("#91b7c4"), 2.0)
