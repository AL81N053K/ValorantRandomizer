extends Control

@export var agents : Array[String] = ["Brimstone","Viper","Omen","Killjoy","Cypher","Sova","Sage","Phoenix","Jett","Reyna","Raze","Breach","Skye","Yoru","Astra","KAYO","Chamber","Neon","Fade","Harbor","Gekko","Deadlock","Iso"]
@onready var grid := $AgentSelection/Grid
@onready var RGP := $RandomGeneratorPanel
@onready var RGPL := $RandomGeneratorPanel/Content/List
var rng_list := []

func _ready() -> void:
	agents.sort()
	grid.columns = 7
	
	for agent in agents:
		var button = Button.new()
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.expand_icon = true
		button.custom_minimum_size = Vector2(1000/grid.columns,1000/grid.columns)
		button.toggle_mode = true
		var file = ResourceLoader.load("res://agents/%s.png" % [agent])
		var icon = file if file else ResourceLoader.load("res://agents/Shatter.png")
		button.icon = icon
		button.text = agent
		button.disabled = false if file else true
		button.button_pressed = true if file else false
		grid.call_deferred("add_child",button)

func toggle_selection() -> void:
	for btn:Button in grid.get_children():
		btn.button_pressed = not btn.button_pressed 

func enable_all() -> void:
	for btn:Button in grid.get_children():
		btn.button_pressed = true

func disable_all() -> void:
	for btn:Button in grid.get_children():
		btn.button_pressed = false

func scale_value_changed(value: float) -> void:
	grid.columns = int(value)
	for button:Button in grid.get_children():
		button.custom_minimum_size = Vector2(1000.0/value,1000.0/value)

func randomize_pressed() -> void:
	RGP.get_node("AnimationPlayer").play("toggle")
	rng_list = []
	var temp_list := []
	for button:Button in grid.get_children():
		if button.button_pressed: temp_list.append(button.text)
	if temp_list.size() == 0: temp_list.append("Shatter")
	while rng_list.size() < 50:
		rng_list += temp_list
		rng_list.shuffle()
	rng_list.shuffle()
	var chosen = rng_list.pick_random()
	RGPL.get_node("AgentTexture").texture = ResourceLoader.load("res://agents/%s.png" % [chosen])
	RGPL.get_node("AgentName").text = chosen
	print("Agent List:",rng_list)
	SoundHandler.play_agent_voice(chosen)

func exit_pressed() -> void:
	RGP.get_node("AnimationPlayer").play_backwards("toggle")
