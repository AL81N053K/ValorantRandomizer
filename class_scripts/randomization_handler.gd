@icon("res://addons/at-icons/node/die.svg")
extends Node
class_name RandomizerHandler

@export var randomize_button : Button
@export var rng_panel : RNGPanel
@export var list_of_panels : Array[ContentPanel]
@export var window_panel : WindowPanel
@export var tool_box : ToolBox

var file_path : String

func _ready() -> void:
	if randomize_button != null: 
		randomize_button.pressed.connect(randomize_result)
	if window_panel != null:
		if window_panel.save_dialog != null: 
			window_panel.save_dialog.file_selected.connect(func(path): 
				file_path = path
				save_preset()
				)
		if window_panel.load_dialog != null: 
			window_panel.load_dialog.file_selected.connect(func(path): 
				file_path = path
				load_preset()
				)
	if tool_box != null:
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.save_button,"pressed",Callable(open_save_panel))
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.load_button,"pressed",Callable(open_load_panel))

func randomize_result() -> void:
	pass

func save_preset() -> void:
	pass

func load_preset() -> void:
	pass

func show_error(text:String) -> void:
	window_panel.accept_dialog.dialog_text = str(text)
	printerr(text)
	show_accpet_panel()

func open_save_panel() -> void:
	if window_panel == null: return printerr(self.name, " doesn't have window panel set.")
	if window_panel.save_dialog == null: return printerr(self.name, " doesn't have save dialog set.")
	window_panel.save_dialog.show()

func open_load_panel() -> void:
	if window_panel == null: return printerr(self.name, " doesn't have window panel set.")
	if window_panel.load_dialog == null: return printerr(self.name, " doesn't have load dialog set.")
	window_panel.load_dialog.show()

func show_accpet_panel() -> void:
	if window_panel == null: return printerr(self.name, " doesn't have window panel set.")
	if window_panel.accept_dialog == null: return printerr(self.name, " doesn't have accept dialog set.")
	window_panel.accept_dialog.show()
