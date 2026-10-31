extends Node2D

signal level_completed
signal level_restarted

const PLAYER_START := Vector2(80.0, 430.0)
const PLATFORM_TOPS: Array[Rect2] = [
	Rect2(0.0, 450.0, 300.0, 90.0),
	Rect2(380.0, 420.0, 180.0, 120.0),
	Rect2(630.0, 375.0, 130.0, 165.0),
	Rect2(800.0, 450.0, 160.0, 90.0),
]

var completed: bool = false
var player: CharacterBody2D


func _ready() -> void:
	player = $Player
	for platform: Rect2 in PLATFORM_TOPS:
		_add_platform(platform)
	_add_goal()
	queue_redraw()


func _process(_delta: float) -> void:
	if not completed and player.global_position.y > 650.0:
		reset_player()


func reset_player() -> void:
	completed = false
	player.reset_to(PLAYER_START)
	level_restarted.emit()


func complete_level() -> void:
	if completed:
		return
	completed = true
	level_completed.emit()


func _add_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.position + rect.size * 0.5
	body.name = "Platform_%d" % get_child_count()
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)


func _add_goal() -> void:
	var goal := Area2D.new()
	goal.name = "Exit"
	goal.position = Vector2(900.0, 405.0)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(36.0, 90.0)
	collision.shape = shape
	goal.add_child(collision)
	goal.body_entered.connect(_on_exit_body_entered)
	add_child(goal)


func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
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
	for rect: Rect2 in PLATFORM_TOPS:
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
