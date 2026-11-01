extends Node

const AUDIO_CONFIG_PATH := "user://audio.cfg"

@export var music_stream: AudioStream = preload("res://assets/audio/through_the_snow.ogg")
@export_range(0.0, 1.0, 0.01) var music_volume: float = 0.35
var muted: bool = false
var playback_requested: bool = false
var music_player: AudioStreamPlayer
var audio_config_path: String = AUDIO_CONFIG_PATH


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.finished.connect(_on_music_finished)
	add_child(music_player)
	_load_preferences()
	var level: Node = get_parent().get_node("Level")
	level.run_began.connect(start_music)
	level.run_restarted.connect(stop_music)
	level.level_completed.connect(stop_music)
	if music_stream != null:
		music_player.stream = music_stream
	_apply_audio_settings()


func start_music() -> void:
	playback_requested = true
	if music_stream != null and not music_player.playing:
		music_player.play()


func stop_music() -> void:
	playback_requested = false
	if music_player != null:
		music_player.stop()


func is_music_requested() -> bool:
	return playback_requested


func set_muted(value: bool) -> void:
	muted = value
	_apply_audio_settings()
	_save_preferences()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_apply_audio_settings()
	_save_preferences()


func _apply_audio_settings() -> void:
	if music_player == null:
		return
	music_player.volume_db = linear_to_db(maxf(music_volume, 0.0001))
	music_player.stream_paused = muted


func _on_music_finished() -> void:
	if playback_requested and music_stream != null:
		music_player.play()


func _load_preferences() -> void:
	var config := ConfigFile.new()
	if config.load(audio_config_path) != OK:
		return
	music_volume = clampf(float(config.get_value("music", "volume", music_volume)), 0.0, 1.0)
	muted = bool(config.get_value("music", "muted", muted))


func _save_preferences() -> void:
	var config := ConfigFile.new()
	config.set_value("music", "volume", music_volume)
	config.set_value("music", "muted", muted)
	var save_error: Error = config.save(audio_config_path)
	if save_error != OK:
		push_warning("Could not save audio preferences: %s" % error_string(save_error))
