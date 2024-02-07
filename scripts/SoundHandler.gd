extends Node

@onready var MusicNode := $Music
@onready var AgentNode := $AgentVoiceLine
@onready var SFXNode := $SFX

func play_map_music(map_name:String):
	MusicNode.stop()
	MusicNode.stream = load("res://audio/%s_Theme.mp3" % [map_name])
	MusicNode.play()

func play_agent_voice(agent_name:String):
	AgentNode.stop()
	AgentNode.stream = load("res://audio/sfx/agents/%sPick.mp3" % [agent_name])
	AgentNode.play()

func play_sfx_sound(sfx:String, volume:=0.0, pitch:=1.0):
	SFXNode.stop()
	SFXNode.volume_db = volume
	SFXNode.pitch_scale = pitch
	SFXNode.stream = load("res://audio/sfx/%s.mp3" % [sfx])
	SFXNode.play()

func fade_music():
	var tween = get_tree().create_tween()
	tween.tween_property(MusicNode,"volume",-80,.4)
	await tween.finished
	MusicNode.stop()
	
