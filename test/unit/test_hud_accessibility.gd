extends GutTest

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")


func test_existing_hud_labels_use_readable_high_contrast_styles() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var labels: Array[Label] = [
		game.get_node("HUD/Instructions"),
		game.get_node("HUD/Completion"),
		game.get_node("HUD/Passage"),
		game.get_node("HUD/DashStatus"),
	]

	for label: Label in labels:
		var style: StyleBox = label.get_theme_stylebox("normal")
		assert_gte(label.get_theme_font_size("font_size"), 18, "%s should use readable text size." % label.name)
		assert_gte(label.get_theme_font_size("font_size") * (640.0 / 960.0), 16.0,
			"%s text should remain at least 16 px at a 640x360 viewport." % label.name)
		assert_not_null(style, "%s should sit on a distinct backing." % label.name)
		if style == null:
			continue
		var flat_style: StyleBoxFlat = style as StyleBoxFlat
		assert_not_null(flat_style, "%s backing should expose a solid contrast color." % label.name)
		if flat_style == null:
			continue
		assert_gte(_contrast_ratio(label.get_theme_color("font_color"), flat_style.bg_color), 4.5,
			"%s text should meet WCAG AA contrast for normal text." % label.name)


func _contrast_ratio(first: Color, second: Color) -> float:
	var lighter: float = maxf(_relative_luminance(first), _relative_luminance(second))
	var darker: float = minf(_relative_luminance(first), _relative_luminance(second))
	return (lighter + 0.05) / (darker + 0.05)


func _relative_luminance(color: Color) -> float:
	var red: float = _linear_channel(color.r)
	var green: float = _linear_channel(color.g)
	var blue: float = _linear_channel(color.b)
	return 0.2126 * red + 0.7152 * green + 0.0722 * blue


func _linear_channel(channel: float) -> float:
	if channel <= 0.04045:
		return channel / 12.92
	return pow((channel + 0.055) / 1.055, 2.4)
