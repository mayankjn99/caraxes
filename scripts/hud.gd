extends CanvasLayer

@onready var completion_label: Label = $Completion


func _ready() -> void:
	var level: Node = get_node("../Level")
	level.level_completed.connect(_show_completion)
	level.level_restarted.connect(_hide_completion)


func _show_completion() -> void:
	completion_label.visible = true


func _hide_completion() -> void:
	completion_label.visible = false
