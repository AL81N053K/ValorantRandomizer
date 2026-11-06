@icon("res://addons/at-icons/control/script.svg")
extends Control

@export var menu_button : Button
@export var menu_container : MenuContainer
@export var panel : Panel
@export var button_list : Container
@export var block_shade : ColorRect
@export var anim_player : AnimationPlayer
@export var toggle_animation : AnimationLibrary
@export_group("Settings","settings_")
@export var settings_button : BoxLinkButton
@export var settings_panel : BoxMenu

var shown : bool = false
var slot : int = 0
var keycodes : Array[Key] = [KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0]
var unicodes : Array[int] = [49,50,51,52,53,54,55,56,57,48]

func _ready() -> void:
	menu_button.pressed.connect(toggle_menu)
	panel.set_position(Vector2(-1920,0))
	
	anim_player.add_animation_library(&"",toggle_animation)
	
	create_buttons()
	settings_button.box_to_link = settings_panel
	settings_button.box_link_pressed.connect(menu_container.change_panel)
	settings_button.pressed.connect(hide_menu)
	

func toggle_menu() -> void:
	if shown: hide_menu()
	else: show_menu()

func show_menu() -> void:
	if shown: return
	shown = true
	if GlobalSettings.get_setting(&"General",&"skip_animations"):
		panel.position.x = 0.0
		block_shade.visible = true
		block_shade.material.set("shader_parameter/strength",5.0)
		block_shade.material.set("shader_parameter/mix_percentage",0.9)
	else:
		anim_player.play(&"toggle")
	block_shade.mouse_filter = Control.MOUSE_FILTER_STOP
	SoundHandler.play_sfx_sound("Tablet Swipe", 0.0, 1.0)

func hide_menu() -> void:
	if not shown: return
	shown = false
	if GlobalSettings.get_setting(&"General",&"skip_animations"):
		panel.position.x = -1920.0
		block_shade.visible = false
		block_shade.material.set("shader_parameter/strength",0.0)
		block_shade.material.set("shader_parameter/mix_percentage",0.0)
	else:
		anim_player.play_backwards(&"toggle")
	block_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	SoundHandler.play_sfx_sound("Tablet Swipe", 0.0, 0.8)

func _update_shader(parameter:String,new_value) -> void:
	block_shade.material.set_shader_parameter(parameter,new_value)

func create_buttons() -> void:
	for child : BoxMenu in menu_container.get_children():
		child.transition_finished.connect(func (): menu_container.can_change = true)
		if not child.ignore_add:
			var button = BoxLinkButton.new()
			button.flat = true
			button.box_to_link = child
			button.text = str(child.name.trim_suffix("Randomizer").to_camel_case().capitalize())
			button.name = str(child.name,"Button")
			button.icon = child.button_icon
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
