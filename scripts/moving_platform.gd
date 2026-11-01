extends AnimatableBody2D

@export var platform_size: Vector2 = Vector2(120.0, 24.0)

var _start_position: Vector2 = Vector2.ZERO
var _end_position: Vector2 = Vector2.ZERO
var _travel_duration: float = 2.0
var _elapsed: float = 0.0


func _ready() -> void:
	sync_to_physics = true
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = platform_size
	collision.shape = shape
	add_child(collision)


func configure_motion(start_position: Vector2, end_position: Vector2, travel_duration: float) -> void:
	_start_position = start_position
	_end_position = end_position
	_travel_duration = maxf(travel_duration, 0.001)
	_elapsed = 0.0
	position = _start_position


func _physics_process(delta: float) -> void:
	advance_motion(delta)


func advance_motion(delta: float) -> void:
	_elapsed = fposmod(_elapsed + maxf(delta, 0.0), _travel_duration * 2.0)
	var progress := _elapsed / _travel_duration
	if progress > 1.0:
		progress = 2.0 - progress
	position = _start_position.lerp(_end_position, progress)


func _draw() -> void:
	var platform_rect := Rect2(-platform_size * 0.5, platform_size)
	draw_rect(Rect2(platform_rect.position.x, platform_rect.position.y + 7.0,
		platform_rect.size.x, platform_rect.size.y - 7.0), Color("#769eae"))
	draw_rect(Rect2(platform_rect.position.x, platform_rect.position.y + 4.0,
		platform_rect.size.x, 7.0), Color("#a5c8d2"))
	draw_rect(Rect2(platform_rect.position.x, platform_rect.position.y,
		platform_rect.size.x, 7.0), Color("#f3fbf7"))
	draw_line(Vector2(platform_rect.position.x + 8.0, platform_rect.position.y + 9.0),
		Vector2(platform_rect.end.x - 8.0, platform_rect.position.y + 9.0), Color.WHITE, 2.0)
