extends Control

@onready var MenuBoxes = $MenuBoxes
@onready var MenuButtons = $HoverMenu/Container/List/ButtonList
@onready var VolumeList = %VolumeList

@export var currentlyVisible : BoxMenu

func _ready() -> void:
	_verification_check()
	volume_control()
	currentlyVisible.modulate = Color(1,1,1,1)

func _verification_check():
	var mbox := []
	var mbut := []
	if MenuBoxes.get_children() == []: printerr("There are no children in MenuBoxes")
	else:
		for box in MenuBoxes.get_children():
			if box is BoxMenu:
				mbox.append(box)
	if MenuButtons.get_children() == []: printerr("There are no children in MenuButtons")
	else:
		for but in MenuButtons.get_children():
			if but is BoxLinkButton: 
				mbut.append(but)
				but.box_link_pressed.connect(switch_scene.bind(but))

func volume_control():
	for setting in VolumeList.get_children():
		setting.get_node("ToggleAudio").toggled.connect(toggle_audio.bind(setting.name))
		setting.get_node("V/Slider").value_changed.connect(change_volume.bind(setting.name,setting.get_node("V/Indicator"),setting.get_node("ToggleAudio")))
		setting.get_node("V/Indicator").text = str(setting.name,": ",setting.get_node("V/Slider").value,"%")

func toggle_audio(toggle:bool,audio:String):
	AudioServer.set_bus_mute(AudioServer.get_bus_index(audio),!toggle)

func change_volume(volume:float,audio:String,indicator:Label,toggle_button:Button):
	if AudioServer.is_bus_mute(AudioServer.get_bus_index(audio)) and volume > 0: 
		AudioServer.set_bus_mute(AudioServer.get_bus_index(audio), false)
		toggle_button.button_pressed = true
	if not AudioServer.is_bus_mute(AudioServer.get_bus_index(audio)) and volume <= 0: 
		AudioServer.set_bus_mute(AudioServer.get_bus_index(audio), true)
		toggle_button.button_pressed = false
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio),(-60.0 + (60.0 * (volume/100.0))))
	indicator.text = str(audio,": ",volume,"%")

func switch_scene(box: BoxMenu, id_object):
	print(id_object)
	if currentlyVisible != box:
		if currentlyVisible: currentlyVisible.slide_out()
		box.slide_in(.1)
		$HoverMenu/Button.button_pressed = false
		currentlyVisible = box

func _on_button_toggled(toggled_on: bool) -> void:
	var tween = get_tree().create_tween()
	if toggled_on:
		SoundHandler.play_sfx_sound("Tablet Swipe")
		tween.tween_property($HoverMenu, "position", Vector2(0,0), .17).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property($ColorEffect2, "color", Color(Color.BLACK, 0.7), .17).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		$ColorEffect2.mouse_filter = MOUSE_FILTER_STOP
		$HoverMenu/Button.text = "<\n\n<\n\n<\n\n<\n\n<"
	else:
		SoundHandler.play_sfx_sound("Tablet Swipe", -.15, .8)
		tween.tween_property($HoverMenu, "position", Vector2(-440,0), .17).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property($ColorEffect2, "color", Color(Color.BLACK, 0), .17).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		$ColorEffect2.mouse_filter = MOUSE_FILTER_IGNORE
		$HoverMenu/Button.text = ">\n\n>\n\n>\n\n>\n\n>"
