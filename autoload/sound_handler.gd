@icon("res://addons/at-icons/node/headphones.svg")
extends Node

@onready var music_node := $Music
@onready var agent_node := $AgentVoiceLine
@onready var sfx_node := $SFX

func play_audio(category:String,chosen:String) -> void:
	match category:
		"map": 
			play_map_music(chosen)
		"agent":
			play_agent_voice(chosen)
		_:
			pass

func play_map_music(map_name:String):
	var audio = load(str(Constants.PATHS.get(&"audio"),"map/",map_name,".mp3"))
	if music_node.stream == audio: return
	music_node.stop()
	music_node.stream = audio
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
	
