extends GutTest


func test_project_scales_2d_canvas_while_preserving_scene_aspect() -> void:
	assert_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items",
		"2D content should scale to fit the browser canvas.")
	assert_eq(ProjectSettings.get_setting("display/window/stretch/aspect"), "keep",
		"The 16:9 scene should keep its aspect ratio at supported browser sizes.")
