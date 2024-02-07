extends Control

@export var primary_weapons : Array[String] = ["Stinger","Spectre","Bucky","Judge","Bulldog","Guardian","Phantom","Vandal","Marshal","Outlaw","Operator","Ares","Odin"]
@export var secondary_weapons : Array[String] = ["Classic","Shorty","Frenzy","Ghost","Sheriff"]
var options : Array = [["IncludeKnife","Include Knife \n(adds to primary)", false],["OneWeapon","Only one Primary/Sidearm",false],["ArmorRandom","Randomize Shield \n(uncheck = Heavy Shield)",true]] #[Node name, Option name, Pressed?]
@onready var options_list := $WeaponSelection/Options/Scroll/List
@onready var pw_list := $WeaponSelection/PrimaryWeapons/Scroll/List
@onready var sw_list := $WeaponSelection/SecondaryWeapons/Scroll/List
@onready var RGP := $RandomGeneratorPanel
var pw_rng_list := []
var sw_rng_list := []
var rng_list := []
var shield

func _ready() -> void:
	_create_list(primary_weapons,pw_list)
	_create_list(secondary_weapons,sw_list)
	for option in options:
		var button = CheckBox.new()
		button.custom_minimum_size = Vector2(500,50)
		button.name = option[0]
		button.text = option[1]
		button.button_pressed = option[2]
		options_list.call_deferred("add_child",button)

func _create_list(objects:Array,list:Node):
	for object in objects:
		var button = Button.new()
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.expand_icon = true
		button.custom_minimum_size = Vector2(500,115)
		button.toggle_mode = true
		var file = ResourceLoader.load("res://weapons/%s_icon.png" % [object])
		var icon = file if file else ResourceLoader.load("res://weapons/GoldenGun.png")
		button.icon = icon
		button.text = object
		button.disabled = false if file else true
		button.button_pressed = true if file else false
		list.call_deferred("add_child",button)

func toggle_selection() -> void:
	for btn:Button in pw_list.get_children():
		btn.button_pressed = not btn.button_pressed 
	for btn:Button in sw_list.get_children():
		btn.button_pressed = not btn.button_pressed 

func enable_all() -> void:
	for btn:Button in pw_list.get_children():
		btn.button_pressed = true
	for btn:Button in sw_list.get_children():
		btn.button_pressed = true

func disable_all() -> void:
	for btn:Button in pw_list.get_children():
		btn.button_pressed = false
	for btn:Button in sw_list.get_children():
		btn.button_pressed = false

func combine_list():
	rng_list.append_array(pw_rng_list)
	rng_list.append_array(sw_rng_list.filter(func(item): return item != "None"))
	rng_list.shuffle()
	rng_list.shuffle()
	rng_list.shuffle()

func random_shield():
	shield = ["No Shields","Light Shields","Heavy Shields"].pick_random() if options_list.get_node("ArmorRandom").button_pressed else "Heavy Shields"

func randomize_pressed() -> void:
	pw_rng_list = []
	sw_rng_list = []
	rng_list = []
	var temp_list := []
	for button:Button in pw_list.get_children():
		if button.button_pressed: temp_list.append(button.text)
	if options_list.get_node("IncludeKnife").button_pressed: temp_list.append("Knife") 
	if temp_list.size() == 0: temp_list.append("GoldenGun")
	while pw_rng_list.size() < 50:
		pw_rng_list += temp_list
		pw_rng_list.shuffle()
	
	temp_list = []
	for button:Button in sw_list.get_children():
		if button.button_pressed: temp_list.append(button.text)
	if temp_list.size() == 0: temp_list.append("None")
	while sw_rng_list.size() < 50:
		sw_rng_list += temp_list
		sw_rng_list.shuffle()
	
	random_shield()
	if options_list.get_node("OneWeapon").button_pressed:
		combine_list()
		var chosen = rng_list.pick_random()
		%PrimaryWeapon.get_node("Image").texture = ResourceLoader.load("res://weapons/%s_icon.png" % [chosen])
		%PrimaryWeapon.get_node("Label").text = chosen
		%SecondaryWeapon.get_node("Image").texture = ResourceLoader.load("res://weapons/None_icon.png")
		%SecondaryWeapon.get_node("Label").text = ""
		%Shield.get_node("Image").texture = ResourceLoader.load("res://weapons/%s.png" % [shield])
		%Shield.get_node("Label").text = shield
		print("List:",rng_list)
	else:
		var chosen = pw_rng_list.pick_random()
		%PrimaryWeapon.get_node("Image").texture = ResourceLoader.load("res://weapons/%s_icon.png" % [chosen])
		%PrimaryWeapon.get_node("Label").text = chosen
		chosen = sw_rng_list.pick_random()
		%SecondaryWeapon.get_node("Image").texture = ResourceLoader.load("res://weapons/%s_icon.png" % [chosen])
		%SecondaryWeapon.get_node("Label").text = chosen
		%Shield.get_node("Image").texture = ResourceLoader.load("res://weapons/%s.png" % [shield])
		%Shield.get_node("Label").text = shield
		print("Primary List:",pw_rng_list)
		print("Sidearm List:",sw_rng_list)
	
	RGP.get_node("AnimationPlayer").play("toggle")

func exit_pressed() -> void:
	RGP.get_node("AnimationPlayer").play_backwards("toggle")
