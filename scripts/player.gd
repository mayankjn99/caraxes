extends CharacterBody2D

@export var move_speed: float = 260.0
@export var jump_speed: float = 470.0
@export var gravity: float = 1200.0


func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	var jump_pressed: bool = Input.is_action_just_pressed("jump")
	apply_controls(direction, jump_pressed)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func apply_controls(direction: float, jump_pressed: bool) -> void:
	velocity.x = direction * move_speed
	if jump_pressed and is_on_floor():
		velocity.y = -jump_speed


func reset_to(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO


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
