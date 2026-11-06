extends Node

const DEFAULT_SETTINGS : Dictionary = {
	&"Audio": {
		&"music_linear": 1.0,
		&"sfx_linear": 1.0,
		&"music_mute": false,
		&"sfx_mute": false,
	},
	&"General": {
		&"true_randomness": false,
		&"skip_animations": false,
	}
}
const SAVE_PATH : String = "user://global.ini"

var current_settings : Dictionary
var config := ConfigFile.new()

func _ready() -> void:
	load_data()

func save_data() -> void:
	config.load(SAVE_PATH)
	for section in current_settings.keys():
		for setting in current_settings[section].keys():
			config.set_value(section,setting,current_settings[section][setting])
	config.save(SAVE_PATH)

func load_data() -> void:
	config.load(SAVE_PATH)
	current_settings = DEFAULT_SETTINGS.duplicate(true)
	for section in config.get_sections():
		if not current_settings.has(section):
			continue
		for setting in config.get_section_keys(section):
			if current_settings[section].has(setting):
				current_settings[section][setting] = config.get_value(section,setting,DEFAULT_SETTINGS[section].get(setting))
	
	prints("Settings:",current_settings)

func update_setting(section : StringName, setting: StringName, value : Variant) -> void:
	setting = setting.to_lower()
	if not current_settings.has(section): return printerr(section, " does not exists.")
	if not current_settings[section].has(setting): return printerr(section, " doesn't have ",setting)
	if typeof(current_settings[section][setting]) != typeof(value): printerr(value, " is type of ", typeof(value), " was looking for ", typeof(current_settings[section][setting]))
	current_settings[section][setting] = value
	save_data()

func get_setting(section : StringName, setting: StringName) -> Variant:
	setting = setting.to_lower()
	if not current_settings.has(section): 
		printerr(section, " does not exists.")
		return null
	if not current_settings[section].has(setting): 
		printerr(section, " doesn't have ",setting)
		return null
	return current_settings[section][setting]

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_data()
		get_tree().quit() # default behavior
