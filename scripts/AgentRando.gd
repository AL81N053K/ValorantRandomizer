extends MarginContainer

@export var controller_node : Node
@export var duelist_node : Node
@export var initiator_node : Node
@export var sentinel_node : Node
@export var randomize_button : Button
var checkboxes : Array[Button] = []
var lists : Array[VBoxContainer] = []
var agent_types := ["controller","duelist","initiator","sentinel"]
var number_of_agents = 3

var controllers := ["Astra","Brimstone","Harbor","Omen","Viper"]
var duelists := ["Jett","Neon","Phoenix","Raze","Reyna","Yoru"]
var initiators := ["Breach","Fade","Gekko","KAYO","Skye","Sova"]
var sentinels := ["Chamber","Cypher","Deadlock","Killjoy","Sage"]

func _ready() -> void:
	randomize_button.pressed.connect(random_agent)
	$Spacing/Randomize/Container/V/H/SpinBox.value_changed.connect(update_number)
	for n in agent_types:
		var checkbox = get_node("%s/CheckBox" % get("%s_node" % n).get_path())
		checkboxes.append(checkbox)
		checkbox.pressed.connect(group_toggle.bind(checkbox))
		lists.append(get_node("%s/List" % get("%s_node" % n).get_path()))
		for a in get("%ss" % n):
			var button = CheckBox.new()
			button.button_pressed = true
			button.text = a
			button.name = a
			button.alignment = HORIZONTAL_ALIGNMENT_RIGHT
			button.expand_icon = true
			button.icon = load("res://agents/%s.webp" % a)
			get_node("%s/List" % get("%s_node" % n).get_path()).add_child(button)

func group_toggle(button:Button):
	var btn_name = button.text.trim_suffix("s").to_lower()
	var index = agent_types.find(btn_name)
	var agents = lists[index].get_children()
	var test := 0
	for a in agents:
		test += 1 if a.button_pressed == false else 0
	for a in agents:
		a.button_pressed = true if test > 0 else false

func update_number(value:float):
	$Spacing/Randomize/Container/V/H/Label.text = str(value)
	number_of_agents = value

func random_agent():
	for child in $Spacing/Randomize/Container/Agents/H.get_children():
		$Spacing/Randomize/Container/Agents/H.remove_child(child)
	var agents = []
	for n in lists:
		for a in n.get_children():
			if a.button_pressed == true: agents.append(a.text)
	randomize()
	agents.shuffle()
	var temp = -1
	for a in agents:
		temp += 1
		if temp >= number_of_agents: break
		var img = TextureRect.new()
		img.texture = load("res://agents/%s.webp" % a)
		img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		img.custom_minimum_size = Vector2(128,128)
		$Spacing/Randomize/Container/Agents/H.add_child(img)
