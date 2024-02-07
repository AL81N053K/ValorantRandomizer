extends MarginContainer

@export var list_node : Node
@export var name_node : Node
@export var bg_node : Node
const MAPS = ["Ascent","Bind","Breeze","Fracture","Haven","Icebox","Lotus","Pearl","Split"]

func _ready() -> void:
	for map in MAPS:
		var button = CheckBox.new()
		button.text = map
		button.button_pressed = true
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		if not get_node_or_null(list_node.get_path()) == null:
			list_node.add_child(button)

func _on_button_pressed() -> void:
	if get_node_or_null(list_node.get_path()) == null or get_node_or_null(name_node.get_path()) == null or get_node_or_null(bg_node.get_path()) == null: return
	var list = list_node.get_children()
	var selected_maps := []
	for l in list:
		if l.button_pressed == true: 
			selected_maps.append(l.text)
		else :
			continue
	randomize()
	if not selected_maps.is_empty():
		selected_maps.shuffle()
		name_node.text = selected_maps[0]
		var map_img = load("res://maps/%s.webp" % selected_maps[0])
		if map_img != null: bg_node.texture = map_img
