@tool
@icon("res://addons/at-icons/node/window.svg")
class_name WindowPanel
extends Node

@export var save_dialog : FileDialog :
	set(new):
		save_dialog = new
		update_configuration_warnings()
@export var load_dialog : FileDialog :
	set(new):
		load_dialog = new
		update_configuration_warnings()
@export var accept_dialog : AcceptDialog :
	set(new):
		accept_dialog = new
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if save_dialog == null: warnings.append("Save Dialog is missing")
	if load_dialog == null: warnings.append("Load Dialog is missing")
	if accept_dialog == null: warnings.append("Accept Dialog is missing")
	return warnings
