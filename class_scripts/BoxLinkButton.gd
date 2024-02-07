class_name BoxLinkButton
extends Button

signal box_link_pressed(box)

@export var box_to_link : BoxMenu

func _ready() -> void:
	self.pressed.connect(_change_view)

func _change_view():
	if box_to_link != null:
		emit_signal("box_link_pressed", box_to_link)
	else:
		printerr("Button \"%s\" doesn't have a link." % [self.name])
