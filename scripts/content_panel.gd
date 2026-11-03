@icon("res://addons/at-icons/control/archive.svg")
class_name ContentPanel
extends Control

@export_group("Defaults")
@export var name_icon : StringName
@export var perfect_rect : bool = false
@export var min_size : Vector2 = Vector2(1500,1000)
@export var max_size : Vector2 = Vector2(-1,-1)
@export var button_style : Theme = preload("uid://4brdb7s7jq0f")
@export_group("List")
@export var list : Array = []
@export var sort_list : bool = false
@export var grid : Container
@export_subgroup("Grid size","grid_")
@export_range(1,6,1) var grid_default_size_tick : int = 2
@export var grid_default_min : int = 1 :
	set(new):
		grid_default_min = clampi(new,1,grid_default_max)
@export var grid_default_max : int = 6 :
	set(new):
		grid_default_max = clampi(new,grid_default_min,100)
@export_group("Nodes")
@export var tool_box : ToolBox
@export var rng_panel_texture : TextureRect
@export var rng_panel_label : Label

var grid_count : int 

func _ready() -> void:
	if tool_box != null:
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.toggle_selection_button,"pressed",Callable(toggle_selection))
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.enable_all_button,"pressed",Callable(enable_all))
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.disable_all_button,"pressed",Callable(disable_all))
		ToolBox._is_toolbox_option_valid(tool_box,tool_box.scale_slider,"value_changed",Callable(scale_value_changed))
	
	grid_count = Constants.linear_interpolation(grid_default_min,grid_default_max,float(grid_default_size_tick-1)/5)
	if sort_list: list.sort()
	grid.columns = grid_count
	if tool_box != null and tool_box.scale_slider != null:tool_box.scale_slider.call_deferred("set","value",grid_default_size_tick)
	
	print(self.name,"\nstart: ",min_size.x * grid_count,"\ndefault max (",grid_default_max,") - default tick (",grid_default_size_tick,") + 1 = grid count (",grid_default_max - grid_default_size_tick + 1,")\nActual grid count: ",grid_count,"\n--------------------")
	
	for object in list:
		if object is String:
			var button = Button.new()
			button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
			button.expand_icon = true
			button.custom_minimum_size = Vector2(min_size.x * grid_count,min_size.y * grid_count)
			button.custom_maximum_size = Vector2(max_size.x * grid_count,max_size.y * grid_count) if perfect_rect else max_size
			button.toggle_mode = true
			var file = ResourceLoader.load(str(Constants.PATHS.get(name_icon),"%s.png" % [object]))
			var icon = file if file else ResourceLoader.load(str(Constants.PATHS.get(&"images"),"unknown.png"))
			button.icon = icon
			button.text = object
			button.name = object
			button.disabled = false if file else true
			button.button_pressed = true if file else false
			button.theme = button_style
			button.add_to_group(&"Button")
			grid.call_deferred("add_child",button)
		elif object is Array:
			if object[0] is not String or object[1] is not String or object[2] is not bool: return printerr(object," is not supported.")
			var button = CheckBox.new()
			button.name = object[0]
			button.text = object[1]
			button.button_pressed = object[2]
			button.custom_minimum_size = Vector2i(min_size.x/grid.columns,min_size.y/grid.columns)
			button.custom_maximum_size = max_size
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.alignment = HORIZONTAL_ALIGNMENT_CENTER
			button.autowrap_mode = TextServer.AUTOWRAP_WORD
			button.theme = button_style
			button.add_to_group(&"Button")
			button.add_theme_font_size_override("font_size",32)
			grid.call_deferred("add_child",button)
		else: return printerr(object," is not String or Array.")
	
	self.ready.connect(func (): 
		await get_tree().create_timer(0.2).timeout
		scale_value_changed(grid_default_size_tick)
		)

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
	grid.columns = Constants.linear_interpolation(grid_default_max,grid_default_min,float(value -1)/5)
	value = calc_size(value)
	print(min_size.x*value,"|",value)
	for button:Button in grid.get_children():
		button.custom_minimum_size = Vector2(min_size.x*value,min_size.y*value)
		button.custom_maximum_size = Vector2(max_size.x*value,max_size.y*value) if perfect_rect else max_size

func calc_size(value: float) -> float:
	value = clampf(grid_default_min + value - 1,grid_default_min,grid_default_max)
	if (min_size.x * value) * grid.columns > grid.get_parent().size.x - 40: 
		value = ((grid.get_parent().size.x - 40) / grid.columns) / min_size.x
	return value
