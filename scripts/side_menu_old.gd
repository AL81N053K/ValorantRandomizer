@icon("res://addons/at-icons/control/script.svg")
extends Control

@export var toggle_menu_button : Button
@export var button_list : Container
@export var volume_list : Container
@export var block_shade : ColorRect
@export var menu_container : MenuContainer

var slot : int = 0
var keycodes : Array[Key] = [KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0]
var unicodes : Array[int] = [49,50,51,52,53,54,55,56,57,48]
var shown : bool = false

func _ready() -> void:
	toggle_menu_button.pressed.connect(toggle_menu)
	block_shade.mouse_filter = Control.MOUSE_FILTER_STOP if shown else Control.MOUSE_FILTER_IGNORE
	block_shade.modulate = Color(1,1,1,1) if shown else Color(1,1,1,0)
	
	create_buttons()
	
	volume_list.get_node("Music/ToggleAudio").toggled.connect(toggle_bus.bind(&"Music"))
	volume_list.get_node("SFX/ToggleAudio").toggled.connect(toggle_bus.bind(&"SFX"))
	volume_list.get_node("Music/V/Slider").value_changed.connect(update_volume.bind(&"Music",volume_list.get_node("Music/V/Indicator")))
	volume_list.get_node("SFX/V/Slider").value_changed.connect(update_volume.bind(&"SFX",volume_list.get_node("SFX/V/Indicator")))
	update_volume(GlobalSettings.get_setting(&"Audio",&"music_linear"),&"Music",volume_list.get_node("Music/V/Indicator"))
	update_volume(GlobalSettings.get_setting(&"Audio",&"sfx_linear"),&"SFX",volume_list.get_node("SFX/V/Indicator"))
	toggle_bus(GlobalSettings.get_setting(&"Audio",&"music_mute"),&"Music")
	toggle_bus(GlobalSettings.get_setting(&"Audio",&"sfx_mute"),&"SFX")
	volume_list.get_node("Music/ToggleAudio").button_pressed = GlobalSettings.get_setting(&"Audio",&"music_mute")
	volume_list.get_node("SFX/ToggleAudio").button_pressed = GlobalSettings.get_setting(&"Audio",&"sfx_mute")
	volume_list.get_node("Music/V/Slider").value = GlobalSettings.get_setting(&"Audio",&"music_linear")
	volume_list.get_node("SFX/V/Slider").value = GlobalSettings.get_setting(&"Audio",&"sfx_linear")

func create_buttons() -> void:
	for child : BoxMenu in menu_container.get_children():
		if not child.ignore_add:
			var button = BoxLinkButton.new()
			button.box_to_link = child
			button.text = str(child.name.to_camel_case().capitalize())
			button.name = str(child.name,"Button")
			button_list.add_child(button)
			button.set_owner(button_list)
			button.box_link_pressed.connect(menu_container.change_panel)
			button.pressed.connect(hide_menu)
			if slot < keycodes.size():
				var shortcut = Shortcut.new()
				var key_combo = InputEventKey.new()
				key_combo.keycode = keycodes[slot]
				key_combo.unicode = unicodes[slot]
				key_combo.ctrl_pressed = true
				shortcut.events = [key_combo]
				button.shortcut = shortcut
				slot += 1

func toggle_menu() -> void:
	if shown: hide_menu() 
	else: show_menu()

func show_menu() -> void:
	if shown: return
	shown = true
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self,"position",Vector2.ZERO,0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween[1].tween_property(block_shade,"modulate",Color(1,1,1,1),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	toggle_menu_button.text = str("<\n\n<\n\n<\n\n<\n\n<")
	block_shade.mouse_filter = Control.MOUSE_FILTER_STOP
	#block_shade.get_child(0).mouse_filter = Control.MOUSE_FILTER_STOP
	SoundHandler.play_sfx_sound("Tablet Swipe", 0.0, 1.0)

func hide_menu() -> void:
	if not shown: return
	shown = false
	GlobalSettings.save_data()
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self,"position",Vector2(-440,0),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween[1].tween_property(block_shade,"modulate",Color(1,1,1,0),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	toggle_menu_button.text = str(">\n\n>\n\n>\n\n>\n\n>")
	block_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#block_shade.get_child(0).mouse_filter = Control.MOUSE_FILTER_IGNORE
	SoundHandler.play_sfx_sound("Tablet Swipe", 0.0, 0.8)

func toggle_bus(enabled:bool,bus:StringName) -> void:
	GlobalSettings.update_setting(&"Audio",StringName(str(bus.to_lower(),"_mute")),enabled)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus),not enabled)

func update_volume(volume:float,bus:StringName,label:Label) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus),volume)
	GlobalSettings.update_setting(&"Audio",StringName(str(bus.to_lower(),"_linear")),volume)
	label.text = str(bus," ",floori(volume * 100),"%")
