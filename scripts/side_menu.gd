@icon("res://addons/at-icons/control/script.svg")
extends Control

@export var toggle_menu_button : Button
@export var button_list : Container
@export var volume_list : Container
@export var block_shade : ColorRect

var shown : bool = false

func _ready() -> void:
	toggle_menu_button.pressed.connect(toggle_menu)
	block_shade.mouse_filter = Control.MOUSE_FILTER_STOP if shown else Control.MOUSE_FILTER_IGNORE
	block_shade.modulate = Color(1,1,1,1) if shown else Color(1,1,1,0)
	
	volume_list.get_node("Music/ToggleAudio").toggled.connect(toggle_bus.bind(&"Music"))
	volume_list.get_node("SFX/ToggleAudio").toggled.connect(toggle_bus.bind(&"SFX"))
	volume_list.get_node("Music/V/Slider").value_changed.connect(update_volume.bind(&"Music",volume_list.get_node("Music/V/Indicator")))
	volume_list.get_node("SFX/V/Slider").value_changed.connect(update_volume.bind(&"SFX",volume_list.get_node("SFX/V/Indicator")))
	update_volume(1,&"Music",volume_list.get_node("Music/V/Indicator"))
	update_volume(1,&"SFX",volume_list.get_node("SFX/V/Indicator"))

func toggle_menu() -> void:
	shown = not shown
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self,"position",Vector2.ZERO if shown else Vector2(-440,0),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween[1].tween_property(block_shade,"modulate",Color(1,1,1,1) if shown else Color(1,1,1,0),0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	toggle_menu_button.text = str("<\n\n<\n\n<\n\n<\n\n<") if shown else str(">\n\n>\n\n>\n\n>\n\n>")
	block_shade.mouse_filter = Control.MOUSE_FILTER_STOP if shown else Control.MOUSE_FILTER_IGNORE
	#block_shade.get_child(0).mouse_filter = Control.MOUSE_FILTER_STOP if shown else Control.MOUSE_FILTER_IGNORE
	SoundHandler.play_sfx_sound("Tablet Swipe", 0.0, 1.0 if shown else 0.8)

func toggle_bus(enabled:bool,bus:StringName) -> void:
	print(enabled,"|",bus)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus),not enabled)

func update_volume(volume:float,bus:StringName,label:Label) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus),volume)
	label.text = str(bus," ",floori(volume * 100),"%")
