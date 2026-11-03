@icon("res://addons/at-icons/control/push_button.svg")
class_name BoxLinkButton
extends Button

signal box_link_pressed(box)

@export var box_to_link : BoxMenu

func _ready() -> void:
	self.pressed.connect(_change_view)
	self.add_theme_font_size_override(&"font_size",28)

func _change_view():
	if box_to_link != null:
		emit_signal("box_link_pressed", box_to_link)
		SoundHandler.play_sfx_sound("Cursor",0.35,0.7)
	else:
		printerr("Button \"%s\" doesn't have a link." % [self.name])
