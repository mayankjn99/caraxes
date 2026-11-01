extends CanvasLayer

@onready var completion_label: Label = $Completion
@onready var timer_label: Label = $Timer
@onready var passage_label: Label = $Passage
@onready var dash_status_label: Label = $DashStatus
@onready var music_toggle: Button = $MusicToggle
@onready var music_volume_slider: HSlider = $MusicVolume

var level: Node
var player: CharacterBody2D
var audio_manager: Node


func _ready() -> void:
	level = get_node("../Level")
	player = level.player
	audio_manager = get_node("../AudioManager")
	level.level_completed.connect(_show_completion)
	level.level_restarted.connect(_hide_completion)
	level.passage_changed.connect(_show_passage)
	level.dash_unlocked.connect(_show_dash_unlocked)
	music_toggle.pressed.connect(_toggle_music_mute)
	music_volume_slider.value_changed.connect(_set_music_volume)
	music_volume_slider.value = audio_manager.music_volume
	_update_music_toggle()
	_show_passage(level.current_passage)
	_show_dash_unlocked() if level.has_unlocked_dash else _show_dash_locked()
	_update_timer()


func _process(_delta: float) -> void:
	_update_timer()
	_update_dash_status()


func _show_completion() -> void:
	var best_time: float = level.personal_best
	completion_label.text = "Run complete!\nTime: %s   Best: %s" % [
		_format_time(level.elapsed_time),
		_format_time(best_time) if best_time >= 0.0 else "--:--.--",
	]
	completion_label.visible = true


func _show_passage(passage_number: int) -> void:
	passage_label.text = "Passage %d%s" % [
		passage_number,
		" — Moving ice" if passage_number == 2 else " — First ascent",
	]


func _show_dash_unlocked() -> void:
	_update_dash_status()


func _show_dash_locked() -> void:
	dash_status_label.text = "Dash locked — find the marker"


func _update_dash_status() -> void:
	if not level.has_unlocked_dash:
		_show_dash_locked()
	elif player.is_dashing():
		dash_status_label.text = "Dash active"
	elif player.get_dash_cooldown_remaining() > 0.0:
		dash_status_label.text = "Dash recharging"
	else:
		dash_status_label.text = "Dash ready: Shift"


func _hide_completion() -> void:
	completion_label.visible = false
	if level.has_unlocked_dash:
		_show_dash_unlocked()
	else:
		_show_dash_locked()


func _update_timer() -> void:
	timer_label.text = "Time: %s" % _format_time(level.elapsed_time)


func _toggle_music_mute() -> void:
	audio_manager.set_muted(not audio_manager.muted)
	_update_music_toggle()


func _update_music_toggle() -> void:
	var available: bool = audio_manager.music_stream != null
	music_toggle.disabled = not available
	music_volume_slider.editable = available
	music_toggle.text = "No music" if not available else ("Music: Off" if audio_manager.muted else "Music: On")


func _set_music_volume(value: float) -> void:
	audio_manager.set_music_volume(value)


func _format_time(seconds: float) -> String:
	return "%02d:%05.2f" % [int(seconds / 60.0), fmod(seconds, 60.0)]
