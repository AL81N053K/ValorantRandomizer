extends Control

@export var label : Label

func _ready() -> void:
	if label != null:
		label.text = str("Version %s" % [ProjectSettings.get_setting("application/config/version")])
