@icon("res://addons/at-icons/node/archive.svg")
extends Node

const PATHS : Dictionary = {
	&"images":"res://images/",
	&"agents_icon" : "res://images/agents/icons/",
	&"agents_artwork" : "res://images/agents/artwork/",
	&"maps" : "res://images/maps/",
	&"classes" : "res://images/classes/",
	&"weapons_normal" : "res://images/weapons/normal/",
	&"weapons_killfeed" : "res://images/weapons/killfeed/",
	&"audio" : "res://audio/"
}
const DEFAULT_NO_IMAGE = "uid://dn04jsleaxmge";

func get_viewport_size() -> Vector2i:
	return Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))

func linear_interpolation(start:float, end:float, ratio : float) -> float:
	return start + (end - start) * ratio
