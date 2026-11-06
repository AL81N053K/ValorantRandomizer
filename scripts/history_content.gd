extends Control

@export var content_list: VBoxContainer
@export var page_numbers: Label
@export var next_button: Button
@export var back_button: Button
@export var delete_history: Button

var max_count : int = 20
var page_amount : int = 1 :
	set(new):
		page_amount = clampi(new,1,new)
var current_page : int = 0

func _ready() -> void:
	var parent : BoxMenu = get_parent()
	parent.transition_finished.connect(func ():
		HistoryHandler.load_data()
		clear_children()
		current_page = 0
		calculate_page_count()
		create_nodes()
		update_text()
		update_buttons()
		)
	next_button.pressed.connect(func (): change_page(current_page + 1))
	back_button.pressed.connect(func (): change_page(current_page - 1))
	delete_history.pressed.connect(remove_history)

func remove_history() -> void:
	HistoryHandler.clear_history()
	current_page = 0
	clear_children()
	calculate_page_count()
	update_text()
	update_buttons()
	

func clear_children() -> void:
	for child in content_list.get_children():
		child.queue_free()

func create_nodes() -> void:
	var temp_count : int = 0
	while temp_count < max_count:
		if HistoryHandler.all_data.size() <= (temp_count + (current_page * max_count)): return
		var package : Dictionary = HistoryHandler.all_data[temp_count + (current_page * max_count)]
		temp_count += 1
		var container := HistoryBlock.new()
		container.name = str("HistoryBlock%d" % [temp_count])
		content_list.add_child(container)
		container.background_rect.color = Constants.BG_COLORS[package[&"type"]]
		container.time_date_label.text = str("%s %s" % [package[&"time"],package[&"date"]])
		match package[&"type"]:
			&"agent":
				container.title_label.text = str("%d. Agent" % [temp_count + (current_page * max_count)])
				var texture_rect := TextureRect.new()
				texture_rect.custom_minimum_size = Vector2(130,130)
				texture_rect.custom_maximum_size = Vector2(130,130)
				texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"agents_icon"],package[&"content"][0],".png"))
				texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				container.list.add_child(texture_rect)
				var label := Label.new()
				label.text = package[&"content"][0]
				label.label_settings = load("uid://cxaq4am3xh6wj")
				label.custom_minimum_size.y = 130
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				container.list.add_child(label)
				pass
			&"map_normal":
				container.title_label.text = str("%d. Normal Map" % [temp_count + (current_page * max_count)])
				var texture_rect := TextureRect.new()
				texture_rect.custom_minimum_size = Vector2(231,130)
				texture_rect.custom_maximum_size = Vector2(231,130)
				texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"maps"],package[&"content"][0],".png"))
				texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				container.list.add_child(texture_rect)
				var label := Label.new()
				label.text = package[&"content"][0]
				label.label_settings = load("uid://cxaq4am3xh6wj")
				label.custom_minimum_size.y = 130
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				container.list.add_child(label)
				pass
			&"map_skirmish":
				container.title_label.text = str("%d. Skirmish Map" % [temp_count + (current_page * max_count)])
				var texture_rect := TextureRect.new()
				texture_rect.custom_minimum_size = Vector2(231,130)
				texture_rect.custom_maximum_size = Vector2(231,130)
				texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"maps_skirmish"],package[&"content"][0],".png"))
				texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				container.list.add_child(texture_rect)
				var label := Label.new()
				label.text = str("Skirmish ",package[&"content"][0])
				label.label_settings = load("uid://cxaq4am3xh6wj")
				label.custom_minimum_size.y = 130
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				container.list.add_child(label)
				pass
			&"map_team_deathmatch":
				container.title_label.text = str("%d. Team Deathmatch Map" % [temp_count + (current_page * max_count)])
				var texture_rect := TextureRect.new()
				texture_rect.custom_minimum_size = Vector2(231,130)
				texture_rect.custom_maximum_size = Vector2(231,130)
				texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"maps_team_deathmatch"],package[&"content"][0],".png"))
				container.list.add_child(texture_rect)
				var label := Label.new()
				label.text = package[&"content"][0]
				label.label_settings = load("uid://cxaq4am3xh6wj")
				label.custom_minimum_size.y = 130
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				container.list.add_child(label)
				pass
			&"weapon":
				container.title_label.text = str("%d. Arsenal" % [temp_count + (current_page * max_count)])
				for content in package[&"content"]:
					var texture_rect := TextureRect.new()
					texture_rect.custom_minimum_size = Vector2(0,130)
					texture_rect.custom_maximum_size = Vector2(300,130)
					if content[0] == &"weapon":
						texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"weapons_killfeed"],content[1],".png"))
					elif content[0] == &"shield":
						texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"images"],"weapons/",content[1],".png"))
					else:
						texture_rect.texture = ResourceLoader.load(str(Constants.PATHS[&"images"],"unknown.png"))
					texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
					texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					container.list.add_child(texture_rect)
					var label := Label.new()
					label.text = content[1].capitalize()
					label.label_settings = load("uid://cxaq4am3xh6wj")
					label.custom_minimum_size.y = 130
					label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
					container.list.add_child(label)
				pass
			_:
				pass

func calculate_page_count() -> void:
	page_amount = ceili(float(HistoryHandler.all_data.size()) / max_count)

func update_text() -> void:
	page_numbers.text = str("%d out of %d" % [current_page + 1, page_amount])

func update_buttons() -> void:
	back_button.disabled = true if current_page == 0 else false
	next_button.disabled = true if current_page + 1 >= page_amount else false

func change_page(number: int) -> void:
	clear_children()
	current_page = number
	create_nodes()
	update_text()
	update_buttons()
