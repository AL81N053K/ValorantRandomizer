extends Control

@onready var true_randomizer_button : CheckButton = $Container/List/TrueRandomizer/List/H/Toggle
@onready var skip_animations_button: CheckButton = $Container/List/SkipAnimations/List/H/Toggle
@onready var music_panel : PanelContainer = $Container/List/Music
@onready var sfx_panel : PanelContainer = $Container/List/SFX


func _ready() -> void:
	link_general()
	link_audio()
	

func link_general() -> void:
	true_randomizer_button.toggled.connect(func (value): GlobalSettings.update_setting(&"General",&"true_randomness",value))
	true_randomizer_button.button_pressed = GlobalSettings.get_setting(&"General",&"true_randomness")
	skip_animations_button.toggled.connect(func (value): GlobalSettings.update_setting(&"General",&"skip_animations",value))
	skip_animations_button.button_pressed = GlobalSettings.get_setting(&"General",&"skip_animations")
	

func link_audio() -> void:
	music_panel.get_node("List/H/Toggle").toggled.connect(toggle_bus.bind(&"Music"))
	sfx_panel.get_node("List/H/Toggle").toggled.connect(toggle_bus.bind(&"SFX"))
	music_panel.get_node("List/H/Slider").value_changed.connect(update_volume.bind(&"Music",music_panel.get_node("List/Indicator")))
	sfx_panel.get_node("List/H/Slider").value_changed.connect(update_volume.bind(&"SFX",sfx_panel.get_node("List/Indicator")))
	update_volume(GlobalSettings.get_setting(&"Audio",&"music_linear"),&"Music",music_panel.get_node("List/Indicator"))
	update_volume(GlobalSettings.get_setting(&"Audio",&"sfx_linear"),&"SFX",sfx_panel.get_node("List/Indicator"))
	toggle_bus(GlobalSettings.get_setting(&"Audio",&"music_mute"),&"Music")
	toggle_bus(GlobalSettings.get_setting(&"Audio",&"sfx_mute"),&"SFX")
	music_panel.get_node("List/H/Toggle").button_pressed = GlobalSettings.get_setting(&"Audio",&"music_mute")
	sfx_panel.get_node("List/H/Toggle").button_pressed = GlobalSettings.get_setting(&"Audio",&"sfx_mute")
	music_panel.get_node("List/H/Slider").value = GlobalSettings.get_setting(&"Audio",&"music_linear")
	sfx_panel.get_node("List/H/Slider").value = GlobalSettings.get_setting(&"Audio",&"sfx_linear")
	

func toggle_bus(enabled:bool,bus:StringName) -> void:
	GlobalSettings.update_setting(&"Audio",StringName(str(bus.to_lower(),"_mute")),enabled)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus),not enabled)

func update_volume(volume:float,bus:StringName,label:Label) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus),volume)
	GlobalSettings.update_setting(&"Audio",StringName(str(bus.to_lower(),"_linear")),volume)
	label.text = str(bus," ",floori(volume * 100),"%")
