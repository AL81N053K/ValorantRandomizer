@tool
@icon("res://addons/at-icons/control/rotate.svg")
extends PanelContainer
class_name HistoryBlock

const HISTORY_BLOCK_PANEL = preload("uid://co5qykkhfy32n")

var list : HBoxContainer
var title_label : Label
var time_date_label : Label
var background_rect : ColorRect

func _ready() -> void:
	if list != null: return
	list = HBoxContainer.new()
	background_rect = ColorRect.new()
	var vbox := VBoxContainer.new()
	time_date_label = Label.new()
	title_label = Label.new()
	
	self.custom_minimum_size = Vector2(0,140)
	self.custom_maximum_size = Vector2(-1,140)
	self.add_theme_stylebox_override(&"panel",HISTORY_BLOCK_PANEL)
	
	background_rect.name = "BGRect"
	self.add_child(background_rect)
	background_rect.owner = get_tree().edited_scene_root
	list.name = "H"
	self.add_child(list)
	list.owner = get_tree().edited_scene_root
	
	vbox.custom_minimum_size = Vector2(200,0)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.name = "Labels"
	vbox.custom_minimum_size.x = 395
	list.add_child(vbox)
	vbox.owner = get_tree().edited_scene_root
	
	title_label.label_settings = load("uid://cxaq4am3xh6wj")
	title_label.name = "TitleLabel"
	title_label.custom_minimum_size.y = 60
	title_label.custom_maximum_size.y = 60
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	title_label.owner = get_tree().edited_scene_root
	time_date_label.label_settings = load("uid://cxaq4am3xh6wj")
	time_date_label.name = "TimeDateLabel"
	time_date_label.custom_minimum_size.y = 60
	time_date_label.custom_maximum_size.y = 60
	time_date_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vbox.add_child(time_date_label)
	time_date_label.owner = get_tree().edited_scene_root
	
	
