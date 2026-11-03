@icon("res://addons/at-icons/node/headphones.svg")
extends Node

@onready var music_node := $Music
@onready var agent_node := $AgentVoiceLine
@onready var sfx_node := $SFX
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var button_hover: AudioStreamPlayer = $ButtonHover

#
#func _ready()->void:
	#self.ready.connect(func():
		#await get_tree().create_timer(0.2).timeout
		#var buttons: Array = get_tree().get_nodes_in_group("Button")
		#for inst in buttons:
			#print(inst)
			#inst.mouse_entered.connect(on_button_hovered)
			#inst.pressed.connect(on_button_pressed)
		#)
#
#func on_button_hovered() -> void:
	#button_hover.play()
#
#func on_button_pressed()->void:
	#button_click.play()

func play_audio(category:String,chosen:String) -> void:
	print(category)
	match category:
		"map": 
			play_map_music(chosen)
		"agent":
			play_agent_voice(chosen)
		_:
			pass

func play_map_music(map_name:String):
	music_node.stop()
	music_node.stream = load(str(Constants.PATHS.get(&"audio"),"map/",map_name,".mp3"))
	music_node.play()

func play_agent_voice(agent_name:String):
	agent_node.stop()
	agent_node.stream = load(str(Constants.PATHS.get(&"audio"),"agent/",agent_name,".mp3"))
	agent_node.play()

func play_sfx_sound(sfx:String, volume:=0.0, pitch:=1.0):
	sfx_node.stop()
	sfx_node.volume_db = volume
	sfx_node.pitch_scale = pitch
	sfx_node.stream = load(str(Constants.PATHS.get(&"audio"),"sfx/",sfx,".mp3"))
	sfx_node.play()

func fade_music():
	var tween = get_tree().create_tween()
	tween.tween_property(music_node,"volume",-80,.4)
	await tween.finished
	music_node.stop()
	
