@tool
@icon("res://addons/at-icons/node/wrench.svg")
class_name ToolBox
extends MarginContainer

@export var toggle_selection_button : Button :
	set(new):
		toggle_selection_button = new
		update_configuration_warnings()
@export var enable_all_button : Button :
	set(new):
		enable_all_button = new
		update_configuration_warnings()
@export var disable_all_button : Button :
	set(new):
		disable_all_button = new
		update_configuration_warnings()
@export var save_button : Button :
	set(new):
		save_button = new
		update_configuration_warnings()
@export var load_button : Button :
	set(new):
		load_button = new
		update_configuration_warnings()
@export var scale_slider : Slider :
	set(new):
		scale_slider = new
		update_configuration_warnings()

static func _is_toolbox_option_valid(tool_box_node: ToolBox, button_node: Node, signal_name: String, call_func: Callable) -> void:
	if tool_box_node == null: return
	if button_node == null: return
	if button_node.has_signal(signal_name) == false: return
	button_node.connect(signal_name, call_func)
