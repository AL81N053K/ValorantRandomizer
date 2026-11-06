extends RandomizerHandler

var rng_list : Array = []
var history_list : Array = []

func randomize_result() -> void:
	if rng_panel.visible: return
	randomize()
	rng_list.clear()
	get_list()
	if rng_list.size() == 0: get_list(true)
	
	if not GlobalSettings.get_setting(&"General",&"true_randomness"):
		if rng_list.size() > 3:
			for history in history_list:
				var slot = rng_list.find(history)
				if slot != -1: rng_list.remove_at(slot)
	
	var result : Button = rng_list.pick_random()
	history_list.push_front(result)
	if history_list.size() >= 3: history_list.pop_back()
	
	var result_panel : ContentPanel = result.get_parent().get_parent().get_parent()
	result_panel.rng_panel_texture.texture = ResourceLoader.load(str(Constants.PATHS.get(&"maps"),result.text,".png"))
	result_panel.rng_panel_label.text = result.text
	rng_panel.open_panel()
	HistoryHandler.add_data({
		&"type": &"map_normal",
		&"time": Time.get_time_string_from_system(),
		&"date": Time.get_date_string_from_system(),
		&"content": [result.text],
	})
	SoundHandler.play_map_music(result.text)

func get_list(ignore_condition: bool = false) -> void:
	for panel : ContentPanel in list_of_panels:
		for object : Button in panel.grid.get_children():
			if (object.disabled == false and object.button_pressed == true) or ignore_condition:
				rng_list.append(object)

func save_preset() -> void:
	rng_list.clear()
	get_list()
	var list : Array[String]
	for result in rng_list:
		list.append(result.text)
	var save_data : Dictionary = {}
	save_data.set(&"type",&"map")
	save_data.set(&"list",list)
	
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	if file == null: show_error(str("Error while creating a file. ",FileAccess.get_open_error()))
	var json_sting := JSON.stringify(save_data)
	file.store_string(json_sting)
	

func load_preset() -> void:
	if not FileAccess.file_exists(file_path): return show_error(str("File not found."))
	
	var file := FileAccess.open(file_path,FileAccess.READ)
	var json_string := file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK: return show_error(str("JSON parse error ", json.get_error_message()," on line", json.get_error_line()))
	var save_data : Dictionary = json.get_data()
	if save_data.get(&"type") == null: return show_error(str("File is not the correct."))
	if save_data.get(&"type") != &"map": return show_error(str("File is not the correct type."))
	if save_data.get(&"list") == null: return show_error(str("File doesn't have a list."))
	
	print(save_data.get(&"list"))
	var list : Array = save_data.get(&"list")
	for panel : ContentPanel in list_of_panels:
		for object : Button in panel.grid.get_children():
			object.button_pressed = list.has(object.text)
