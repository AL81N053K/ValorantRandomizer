extends RandomizerHandler

var options : Array[String]
var weapon_list : Array[String]
var sidearm_list : Array[String]
var shield_list : Array[String]
var history_list : Array = []

var result : String

func randomize_result() -> void:
	if rng_panel.visible: return
	randomize()
	options.clear()
	weapon_list.clear()
	sidearm_list.clear()
	shield_list.clear()
	
	for option:CheckBox in list_of_panels[0].grid.get_children():
		if option.button_pressed: options.append(option.name)
	for weapon:Button in list_of_panels[1].grid.get_children():
		if weapon.button_pressed and not weapon.disabled: weapon_list.append(weapon.text)
	for sidearm:Button in list_of_panels[2].grid.get_children():
		if sidearm.button_pressed and not sidearm.disabled: sidearm_list.append(sidearm.text)
	if options.has("ArmorRandom"):
		shield_list.append_array(["no_shield","light_shield","regen_shield","heavy_shield"])
	else:
		shield_list.append("heavy_shield")
	if options.has("IncludeKnife") or weapon_list.size() == 0: weapon_list.append("Knife")
	if options.has("OneWeapon"): 
		weapon_list.append_array(sidearm_list)
		sidearm_list.clear()
	
	if not GlobalSettings.get_setting(&"General",&"true_randomness"):
		for history in history_list:
			var slot : int
			if weapon_list.size() > 3:
				slot = weapon_list.find(history)
				if slot != -1: weapon_list.remove_at(slot)
			if sidearm_list.size() > 3:
				slot = sidearm_list.find(history)
				if slot != 1: sidearm_list.remove_at(slot)
	
	var temp_history_save : Array = []
	
	result = weapon_list.pick_random()
	temp_history_save.append([&"weapon",result])
	history_list.push_front(result)
	if history_list.size() >= 5:
		history_list.pop_back()
	list_of_panels[1].rng_panel_label.text = result
	list_of_panels[1].rng_panel_texture.texture = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),result,".png"))
	if sidearm_list.size() > 0:
		result = sidearm_list.pick_random()
		temp_history_save.append([&"weapon",result])
		history_list.push_front(result)
		if history_list.size() >= 5:
			history_list.pop_back()
		list_of_panels[2].rng_panel_label.text = result
		list_of_panels[2].rng_panel_texture.texture = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),result,".png"))
	else:
		list_of_panels[2].rng_panel_label.text = ""
		list_of_panels[2].rng_panel_texture.texture = null
	result = shield_list.pick_random()
	temp_history_save.append([&"shield",result])
	list_of_panels[0].rng_panel_label.text = result.capitalize()
	list_of_panels[0].rng_panel_texture.texture = ResourceLoader.load(str(Constants.PATHS.get(&"images"),"weapons/",result,".png"))
	
	rng_panel.open_panel()
	HistoryHandler.add_data({
		&"type": &"weapon",
		&"time": Time.get_time_string_from_system(),
		&"date": Time.get_date_string_from_system(),
		&"content": temp_history_save,
	})
	SoundHandler.play_sfx_sound("Coin Flung",0.5,randf_range(0.825,1.325))


func save_preset() -> void:
	options.clear()
	weapon_list.clear()
	sidearm_list.clear()
	for option:CheckBox in list_of_panels[0].grid.get_children():
		if option.button_pressed: options.append(option.name)
	for weapon:Button in list_of_panels[1].grid.get_children():
		if weapon.button_pressed and not weapon.disabled: weapon_list.append(weapon.text)
	for sidearm:Button in list_of_panels[2].grid.get_children():
		if sidearm.button_pressed and not sidearm.disabled: sidearm_list.append(sidearm.text)
	
	var save_data : Dictionary = {}
	save_data.set(&"type",&"weapon")
	save_data.set(&"option_list",options)
	save_data.set(&"weapon_list",weapon_list)
	save_data.set(&"sidearm_list",sidearm_list)
	
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
	if save_data.get(&"type") != &"weapon": return show_error(str("File is not the correct type."))
	if save_data.get(&"option_list") == null: return show_error(str("File doesn't have an option list."))
	if save_data.get(&"weapon_list") == null: return show_error(str("File doesn't have a weapon list."))
	if save_data.get(&"sidearm_list") == null: return show_error(str("File doesn't have a sidearm list."))
	
	print(save_data.get(&"option_list"))
	var list : Array = save_data.get(&"option_list")
	for option:CheckBox in list_of_panels[0].grid.get_children():
		option.button_pressed = list.has(option.name)
	
	print(save_data.get(&"weapon_list"))
	list = save_data.get(&"weapon_list")
	for weapon:Button in list_of_panels[1].grid.get_children():
		weapon.button_pressed = list.has(weapon.name)
	
	print(save_data.get(&"sidearm_list"))
	list = save_data.get(&"sidearm_list")
	for sidearm:Button in list_of_panels[2].grid.get_children():
		sidearm.button_pressed = list.has(sidearm.name)
	
	
