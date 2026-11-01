extends GutTest

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")


func test_music_lifecycle_tracks_run_restart_and_completion() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var level: Node = game.get_node("Level")
	var audio: Node = game.get_node("AudioManager")
	var player: CharacterBody2D = game.get_node("Level/Player")

	assert_false(audio.call("is_music_requested"), "Music should wait until a run begins.")
	player.apply_controls(1.0, false)
	assert_true(audio.call("is_music_requested"), "Music should start with the run.")
	level.call("reset_player")
	assert_true(audio.call("is_music_requested"), "Fall recovery should not interrupt the run music.")
	level.call("restart_run")
	assert_false(audio.call("is_music_requested"), "Explicit restart should stop music until the new run starts.")
	player.apply_controls(1.0, false)
	assert_true(audio.call("is_music_requested"), "Music should resume when the restarted run begins.")
	level.set("current_passage", 2)
	level.call("complete_level")
	assert_false(audio.call("is_music_requested"), "Music should stop on final completion.")


func test_music_configuration_and_hud_control_are_accessible() -> void:
	var scene: Node = MAIN_SCENE.instantiate()
	var audio_config_path := "/tmp/frozen_passage_audio_preferences_test.cfg"
	DirAccess.remove_absolute(audio_config_path)
	scene.get_node("AudioManager").set("audio_config_path", audio_config_path)
	var game: Node = add_child_autofree(scene)
	var audio: Node = game.get_node("AudioManager")
	var hud: CanvasLayer = game.get_node("HUD")
	var control: Button = hud.get_node("MusicToggle")
	var volume: HSlider = hud.get_node("MusicVolume")

	assert_true(audio.get("music_player") is AudioStreamPlayer, "Music should use a local AudioStreamPlayer.")
	assert_true(audio.has_method("set_muted"), "Audio manager should expose a mute control.")
	assert_true(audio.has_method("set_music_volume"), "Audio manager should expose music volume control.")
	assert_true(control.visible, "Music control should be visible in the HUD.")
	assert_true(control.focus_mode != Control.FOCUS_NONE, "Music control should be keyboard accessible.")
	assert_false(control.disabled, "A verified local track should enable the music control.")
	assert_eq(control.text, "Music: On", "The HUD should clearly show that music is available.")
	assert_gte(control.get_theme_font_size("font_size") * (640.0 / 960.0), 16.0,
		"Music control text should remain 16 px effective at 640x360.")
	assert_true(volume.visible, "Music volume control should be visible in the HUD.")
	assert_true(volume.focus_mode != Control.FOCUS_NONE, "Music volume control should be keyboard accessible.")
	assert_gte(volume.size.x * (640.0 / 960.0), 120.0,
		"Volume slider should remain wide enough to use at 640x360.")
	var silent_fixture := AudioStreamWAV.new()
	audio.set("music_stream", silent_fixture)
	audio.get("music_player").stream = silent_fixture
	hud.call("_update_music_toggle")
	assert_false(control.disabled, "A configured local stream should enable the music control.")
	control.emit_signal("pressed")
	assert_true(audio.get("muted"), "The HUD toggle should update the audio manager mute state.")
	assert_eq(control.text, "Music: Off", "The HUD toggle should report the muted state.")
	volume.value = 0.65
	assert_almost_eq(audio.get("music_volume"), 0.65, 0.001, "The HUD slider should update normalized music volume.")
	assert_true(FileAccess.file_exists(audio_config_path), "Mute and volume preferences should persist locally.")
	var saved := ConfigFile.new()
	assert_eq(saved.load(audio_config_path), OK, "Saved audio settings should be readable.")
	assert_eq(saved.get_value("music", "muted"), true, "Mute preference should be saved.")
	assert_almost_eq(saved.get_value("music", "volume"), 0.65, 0.001, "Volume preference should be saved.")
	DirAccess.remove_absolute(audio_config_path)


func test_stream_starts_restarts_after_end_and_stops() -> void:
	var game: Node = add_child_autofree(MAIN_SCENE.instantiate())
	var audio: Node = game.get_node("AudioManager")
	var silent_fixture := AudioStreamWAV.new()
	audio.set("music_stream", silent_fixture)
	audio.get("music_player").stream = silent_fixture

	audio.call("start_music")
	assert_true(audio.get("music_player").playing, "A configured local stream should begin playback on run start.")
	audio.call("_on_music_finished")
	assert_true(audio.get("music_player").playing, "An active run should restart the stream when it ends.")
	audio.call("stop_music")
	assert_false(audio.get("music_player").playing, "Stopping the run should stop the stream.")




func test_packaged_winter_music_is_assigned_and_enables_hud_controls() -> void:
	var scene: Node = MAIN_SCENE.instantiate()
	var audio_config_path := "/tmp/frozen_passage_packaged_music_test.cfg"
	DirAccess.remove_absolute(audio_config_path)
	scene.get_node("AudioManager").set("audio_config_path", audio_config_path)
	var game: Node = add_child_autofree(scene)
	var audio: Node = game.get_node("AudioManager")
	var control: Button = game.get_node("HUD/MusicToggle")
	var stream: AudioStream = audio.get("music_stream")

	assert_not_null(stream, "The game should package its verified winter loop locally.")
	assert_true(stream is AudioStreamOggVorbis, "The packaged loop should use Godot's local Ogg Vorbis stream.")
	assert_eq(audio.get("music_player").stream, stream, "AudioManager should assign the packaged stream to its player.")
	assert_false(control.disabled, "A packaged local music track should enable the music control.")
	assert_eq(control.text, "Music: On", "The HUD should show that packaged music is available.")
	audio.call("start_music")
	assert_true(audio.get("music_player").playing, "The packaged local stream should play when the run starts.")
	DirAccess.remove_absolute(audio_config_path)
