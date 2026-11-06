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
	result_panel.rng_panel_texture.texture = ResourceLoader.load(str(Constants.PATHS.get(&"maps_skirmish"),result.text,".png"))
	result_panel.rng_panel_label.text = str("Skirmish ",result.text)
	rng_panel.open_panel()
	HistoryHandler.add_data({
		&"type": &"map_skirmish",
		&"time": Time.get_time_string_from_system(),
		&"date": Time.get_date_string_from_system(),
		&"content": [result.text],
	})
	SoundHandler.play_map_music("Range")

func get_list(ignore_condition: bool = false) -> void:
	for panel : ContentPanel in list_of_panels:
		for object : Button in panel.grid.get_children():
			if (object.disabled == false and object.button_pressed == true) or ignore_condition:
				rng_list.append(object)
