extends CharacterBody2D

signal movement_started

@export var move_speed: float = 260.0
@export var jump_speed: float = 470.0
@export var gravity: float = 1200.0
@export var platform_jump_carry_time: float = 0.12
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.65

var dash_unlocked: bool = false
var controls_enabled: bool = true
var _has_started_moving: bool = false
var _facing_direction: float = 1.0
var _is_dashing: bool = false
var _dash_direction: float = 1.0
var _dash_remaining: float = 0.0
var _dash_cooldown_remaining: float = 0.0
var _platform_jump_carry_velocity: float = 0.0
var _platform_jump_carry_remaining: float = 0.0


func _physics_process(delta: float) -> void:
	if not controls_enabled:
		velocity = Vector2.ZERO
		return
	var direction: float = Input.get_axis("move_left", "move_right")
	var jump_pressed: bool = Input.is_action_just_pressed("jump")
	if Input.is_action_just_pressed("dash"):
		try_dash(direction)
	if _is_dashing:
		velocity.y = 0.0
		move_and_slide()
		advance_dash(delta)
		return
	apply_controls(direction, jump_pressed)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	advance_dash(delta)
	_platform_jump_carry_remaining = maxf(_platform_jump_carry_remaining - delta, 0.0)
	if is_zero_approx(_platform_jump_carry_remaining):
		_platform_jump_carry_velocity = 0.0


func apply_controls(direction: float, jump_pressed: bool) -> void:
	if not is_zero_approx(direction):
		_facing_direction = signf(direction)
	if not _has_started_moving and not is_zero_approx(direction):
		_has_started_moving = true
		movement_started.emit()
	if jump_pressed and is_on_floor():
		_platform_jump_carry_velocity = get_platform_velocity().x
		_platform_jump_carry_remaining = platform_jump_carry_time
		velocity.y = -jump_speed
	velocity.x = direction * move_speed + _platform_jump_carry_velocity


func unlock_dash() -> void:
	dash_unlocked = true


func try_dash(direction: float = 0.0) -> bool:
	if not dash_unlocked or _is_dashing or _dash_cooldown_remaining > 0.0:
		return false
	if not is_zero_approx(direction):
		_facing_direction = signf(direction)
	_dash_direction = _facing_direction
	_dash_remaining = dash_duration
	_dash_cooldown_remaining = dash_cooldown
	_is_dashing = true
	velocity = Vector2(_dash_direction * dash_speed, 0.0)
	return true


func is_dashing() -> bool:
	return _is_dashing


func get_dash_cooldown_remaining() -> float:
	return _dash_cooldown_remaining


func advance_dash(delta: float) -> void:
	_dash_cooldown_remaining = maxf(_dash_cooldown_remaining - delta, 0.0)
	if not _is_dashing:
		return
	_dash_remaining = maxf(_dash_remaining - delta, 0.0)
	if is_zero_approx(_dash_remaining):
		_is_dashing = false


func lock_dash() -> void:
	dash_unlocked = false
	_is_dashing = false
	_dash_remaining = 0.0
	_dash_cooldown_remaining = 0.0


func stop_for_completion() -> void:
	_is_dashing = false
	_dash_remaining = 0.0
	_platform_jump_carry_velocity = 0.0
	_platform_jump_carry_remaining = 0.0
	velocity = Vector2.ZERO
	controls_enabled = false


func reset_to(spawn_position: Vector2, new_run: bool = false) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	controls_enabled = true
	_platform_jump_carry_velocity = 0.0
	_platform_jump_carry_remaining = 0.0
	_is_dashing = false
	_dash_remaining = 0.0
	if new_run:
		_has_started_moving = false


func _draw() -> void:
	# Compact mountaineer silhouette, drawn in the same flat winter style as the level.
	draw_colored_polygon(PackedVector2Array([
		Vector2(-10, 18), Vector2(-12, 5), Vector2(-10, -7), Vector2(-8, -15),
		Vector2(7, -15), Vector2(11, -5), Vector2(11, 11), Vector2(8, 18),
	]), Color("#31566a"))
	# Hood and face.
	draw_circle(Vector2(0, -12), 9, Color("#e9a77f"))
	draw_arc(Vector2(0, -12), 10, PI, TAU, 16, Color("#244455"), 4.0)
	draw_line(Vector2(-8, -7), Vector2(9, -7), Color("#f0c783"), 4.0)
	# Coat seams and boots.
	draw_line(Vector2(0, -4), Vector2(0, 12), Color("#527d8b"), 2.0)
	draw_line(Vector2(-10, 16), Vector2(-3, 16), Color("#233f50"), 4.0)
	draw_line(Vector2(4, 16), Vector2(11, 16), Color("#233f50"), 4.0)
	# Tiny eye facing right.
	draw_circle(Vector2(4, -12), 1.2, Color("#23323b"))
