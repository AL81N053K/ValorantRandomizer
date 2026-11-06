@icon("res://addons/at-icons/node/archive.svg")
extends Node

const PATHS : Dictionary = {
	&"images":"res://images/",
	&"agents_icon" : "res://images/agents/icons/",
	&"agents_artwork" : "res://images/agents/artwork/",
	&"maps" : "res://images/maps/",
	&"maps_skirmish" : "res://images/skirmish/",
	&"maps_team_deathmatch" : "res://images/team_deathmatch/",
	&"classes" : "res://images/classes/",
	&"weapons_normal" : "res://images/weapons/normal/",
	&"weapons_killfeed" : "res://images/weapons/killfeed/",
	&"audio" : "res://audio/"
}
const DEFAULT_NO_IMAGE = "uid://dn04jsleaxmge";
const BG_COLORS := {
	&"weapon": Color(0.212, 0.502, 0.875, 0.4),
	&"agent": Color(0.272, 0.776, 0.295, 0.4),
	&"map_normal": Color(0.895, 0.734, 0.353, 0.4),
	&"map_skirmish": Color(0.789, 0.616, 0.483, 0.4),
	&"map_team_deathmatch": Color(0.547, 0.208, 0.645, 0.4),
	&"history": Color(0.644, 0.796, 0.774, 0.4),
	&"settings": Color(0.403, 0.418, 0.441, 0.4),
}

func get_viewport_size() -> Vector2i:
	return Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))

func linear_interpolation(start:float, end:float, ratio : float) -> float:
	return start + (end - start) * ratio
