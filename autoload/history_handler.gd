extends Node

const HISTORY_FILE : String = "user://history.json"

var all_data : Array = []

func _ready() -> void:
	load_data()

func load_data() -> void:
	if not FileAccess.file_exists(HISTORY_FILE): 
		print_rich("[color=#ffff00]History file not found. Creating new file.")
		save_data()
	
	var file := FileAccess.open(HISTORY_FILE,FileAccess.READ)
	var json_string := file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK: return prints("JSON parse error", json.get_error_message(),"on line", json.get_error_line())
	all_data = json.get_data()
	all_data.sort_custom(sort_history)
	file.close()
	prints("History:",all_data)

func add_data(data : Dictionary) -> void:
	if not data.has(&"type"): return printerr("Sent data does not contain type.")
	if not data.has(&"content"): return printerr("Sent data does not contain content.")
	if not data.has(&"date"): return printerr("Sent data does not contain date.")
	if not data.has(&"time"): return printerr("Sent data does not contain time.")
	all_data.push_front(data)
	all_data.sort_custom(sort_history)
	save_data()

func save_data() -> void:
	var file = FileAccess.open(HISTORY_FILE,FileAccess.WRITE)
	if file == null: prints("Error while saving a file.",FileAccess.get_open_error())
	var json_sting := JSON.stringify(all_data)
	file.store_string(json_sting)
	file.close()

func clear_history() -> void:
	all_data.clear()
	var file = FileAccess.open(HISTORY_FILE,FileAccess.WRITE)
	if file == null: prints("Error while saving a file.",FileAccess.get_open_error())
	var json_sting := JSON.stringify([])
	file.store_string(json_sting)
	file.close()

func sort_history(a : Dictionary, b : Dictionary) -> bool:
	if a.date != b.date:
		return a.date > b.date
	return a.time > b.time
