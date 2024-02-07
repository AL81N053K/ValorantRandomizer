extends MarginContainer

var weapon_types := ["secondary_weapons","primary_weapons","shields"]
var secondary_weapons := ["Classic","Shorty","Frenzy","Ghost","Sheriff"]
var primary_weapons := ["Stinger","Spectre","Bucky","Judge","Bulldog","Guardian","Phantom","Vandal","Marshal","Operator","Ares","Odin","Melee"]
var shields := ["No Shields","Light Shields","Heavy Shields"]

func _ready() -> void:
	$Spacing/Randomize/Button.pressed.connect(random)

func random():
	for w in weapon_types:
		randomize()
		get(w).shuffle()
		var split = w.split("_")
		var text = split[0].capitalize()
		var node = get_node("Spacing/Weapons/%s" % text)
		var image = load("res://weapons/%s.webp" % get(w)[0])
		if image != null: node.get_node("TextureRect").texture = image 
		node.get_node("Label").text = get(w)[0]
