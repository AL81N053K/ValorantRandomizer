@tool
@icon("res://addons/at-icons/control/square_brackets.svg")
class_name MenuContainer
extends MarginContainer

@export var currently_visible : BoxMenu :
	set(new_value):
		if Engine.is_editor_hint():
			if currently_visible != null: 
				currently_visible.modulate = Color(1,1,1,0)
				currently_visible.hide()
			if new_value != null:
				new_value.modulate = Color(1,1,1,1)
				new_value.show()
		previous_visible = currently_visible
		currently_visible = new_value
		update_configuration_warnings()
var previous_visible : BoxMenu

func _init() -> void:
	self.set_anchors_preset(Control.PRESET_FULL_RECT)

func _ready() -> void:
	#for child : BoxMenu in self.get_children():
		#print("%s position: %s\n    rest_position: %s" % [child.name,child.position,child.rest_position])
	pass

func change_panel(new_panel) -> void:
	currently_visible.slide_out(0.1)
	currently_visible = new_panel
	currently_visible.slide_in(0.4)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	
	if currently_visible == null:
		warnings.append("Starting BoxMenu in currently_visible is not set.")
	
	return warnings
