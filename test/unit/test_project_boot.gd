extends GutTest


func test_main_scene_can_be_instantiated_with_a_named_root() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	assert_not_null(main_scene, "The configured main scene must exist.")
	if main_scene == null:
		return

	var instance: Node = add_child_autofree(main_scene.instantiate())
	assert_eq(instance.name, "Main", "The main scene root should be named Main.")
