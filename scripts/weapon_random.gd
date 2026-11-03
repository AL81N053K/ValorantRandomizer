@icon("res://addons/at-icons/control/archive.svg")
extends Control

@export var primary_weapons : Array[String] = ["Stinger","Spectre","Bucky","Judge","Bulldog","Guardian","Phantom","Warden","Vandal","Marshal","Outlaw","Operator","Ares","Odin"]
@export var secondary_weapons : Array[String] = ["Classic","Shorty","Frenzy","Ghost","Bandit","Sheriff"]
@export var options : Array = [["IncludeKnife","Include Knife \n(adds to primary)", false],["OneWeapon","Only one Primary/Sidearm",false],["ArmorRandom","Randomize Shield \n(uncheck = Heavy Shield)",true]] #[Node name, Option name, Pressed?]
@export var options_list : Container
@export var primary_weapons_list : Container
@export var secondary_weapons_list : Container
@export var random_generator_panel : RNGPanel
@export var window_panel : WindowPanel

var pw_rng_list := []
var sw_rng_list := []
var rng_list := []
var shield : String

func _ready() -> void:
	_create_list(primary_weapons,primary_weapons_list)
	_create_list(secondary_weapons,secondary_weapons_list)
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
		var file = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),"%s.png" % [object]))
		var icon = file if file else ResourceLoader.load(str(Constants.PATHS.get(&"images"),"unknown.png"))
		button.icon = icon
		button.text = object
		button.disabled = false if file else true
		button.button_pressed = true if file else false
		list.call_deferred("add_child",button)

func toggle_selection() -> void:
	for btn:Button in primary_weapons_list.get_children():
		btn.button_pressed = not btn.button_pressed 
	for btn:Button in secondary_weapons_list.get_children():
		btn.button_pressed = not btn.button_pressed 

func enable_all() -> void:
	for btn:Button in primary_weapons_list.get_children():
		btn.button_pressed = true
	for btn:Button in secondary_weapons_list.get_children():
		btn.button_pressed = true

func disable_all() -> void:
	for btn:Button in primary_weapons_list.get_children():
		btn.button_pressed = false
	for btn:Button in secondary_weapons_list.get_children():
		btn.button_pressed = false

func combine_list():
	rng_list.append_array(pw_rng_list)
	rng_list.append_array(sw_rng_list.filter(func(item): return item != "None"))
	rng_list.shuffle()
	rng_list.shuffle()
	rng_list.shuffle()

func random_shield():
	shield = ["no_shield","light_shield","regen_shield","heavy_shield"].pick_random() if options_list.get_node("ArmorRandom").button_pressed else "heavy_shield"

func randomize_pressed() -> void:
	pw_rng_list = []
	sw_rng_list = []
	rng_list = []
	var temp_list := []
	for button:Button in primary_weapons_list.get_children():
		if button.button_pressed: temp_list.append(button.text)
	if options_list.get_node("IncludeKnife").button_pressed: temp_list.append("Knife") 
	if temp_list.size() == 0: temp_list.append(primary_weapons)
	while pw_rng_list.size() < 50:
		pw_rng_list += temp_list
		pw_rng_list.shuffle()
	
	temp_list = []
	for button:Button in secondary_weapons_list.get_children():
		if button.button_pressed: temp_list.append(button.text)
	if temp_list.size() == 0: temp_list.append(secondary_weapons)
	while sw_rng_list.size() < 50:
		sw_rng_list += temp_list
		sw_rng_list.shuffle()
	
	random_shield()
	if options_list.get_node("OneWeapon").button_pressed:
		combine_list()
		var chosen = rng_list.pick_random()
		%PrimaryWeapon.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),chosen,".png"))
		%PrimaryWeapon.get_node("Label").text = chosen
		%SecondaryWeapon.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"images"),"weapons/no_shield.png"))
		%SecondaryWeapon.get_node("Label").text = ""
		%Shield.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"images"),"weapons/",shield,".png"))
		%Shield.get_node("Label").text = shield.capitalize()
	else:
		var chosen = pw_rng_list.pick_random()
		%PrimaryWeapon.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),chosen,".png"))
		%PrimaryWeapon.get_node("Label").text = chosen
		chosen = sw_rng_list.pick_random()
		%SecondaryWeapon.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"weapons_normal"),chosen,".png"))
		%SecondaryWeapon.get_node("Label").text = chosen
		%Shield.get_node("Image").texture = ResourceLoader.load(str(Constants.PATHS.get(&"images"),"weapons/",shield,".png"))
		%Shield.get_node("Label").text = shield.capitalize()
	
func _save_selected(path: String) -> void:
	var save_file = FileAccess.open(path,FileAccess.WRITE)
	var temp_list := [[],[],[]]
	for button:Button in primary_weapons_list.get_children():
		if button.button_pressed: temp_list[0].append(button.text)
	for button:Button in secondary_weapons_list.get_children():
		if button.button_pressed: temp_list[1].append(button.text)
	for button:Button in options_list.get_children():
		if button.button_pressed: temp_list[2].append(button.name)
	var to_save = JSON.stringify({
		type = "weapon",
		pw = temp_list[0],
		sw = temp_list[1],
		options = temp_list[2]
	})
	save_file.store_line(to_save)
