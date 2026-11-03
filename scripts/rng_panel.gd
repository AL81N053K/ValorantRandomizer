@tool
@icon("res://addons/at-icons/control/checkerboard_circle.svg")
class_name RNGPanel
extends Control

@export var title_label : Label :
	set(new):
		title_label = new
		update_configuration_warnings()
@export var title_text : String = "UwU" :
	set(new):
		title_text = new
		update_configuration_warnings()
@export var exit_button : Button :
	set(new):
		exit_button = new
		update_configuration_warnings()
@export var animation_player : AnimationPlayer

func _init() -> void:
	update_configuration_warnings()
	

func _ready() -> void:
	if Engine.is_editor_hint():
		self.set_anchors_preset(Control.PRESET_FULL_RECT)
		self.call_deferred("set_custom_minimum_size", Vector2i(1920,1080))
		_add_background()
		_add_container()
		_add_exit_button()
		_add_anim_player()
		self.pivot_offset_ratio = Vector2(0.5,0.5)
	if exit_button != null:
		exit_button.pressed.connect(close_panel)
	title_label.text = str("Your today's lucky %s is..." % title_text)

func _add_anim_player() -> void:
	if animation_player != null: return
	var anim_play = AnimationPlayer.new()
	anim_play.name = "AnimationPlayer"
	anim_play.add_animation_library("",ResourceLoader.load("uid://babvobvm7lhum"))
	#anim_play.set_root("")
	add_child(anim_play)
	anim_play.owner = get_tree().edited_scene_root
	animation_player = anim_play

func _add_exit_button() -> void:
	if exit_button != null: return
	var button = Button.new()
	button.name = "Exit"
	button.text = "X"
	button.custom_minimum_size = Vector2i(60, 60)
	button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	button.set_position(Vector2(-60, 0))
	button.add_theme_font_size_override("font_size", 34)
	add_child(button)
	button.owner = get_tree().edited_scene_root
	exit_button = button

func _add_container() -> void:
	if title_label != null: return
	var margin_container = MarginContainer.new()
	var v_box = VBoxContainer.new()
	var label = Label.new()
	margin_container.name = "Content"
	v_box.name = "List"
	label.name = "Title"
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	#margin_container.set_size(Vector2i(1920,1080))
	add_child(margin_container)
	margin_container.owner = get_tree().edited_scene_root
	
	v_box.alignment = BoxContainer.ALIGNMENT_CENTER
	margin_container.add_child(v_box)
	v_box.owner = get_tree().edited_scene_root
	
	var ls = LabelSettings.new()
	ls.font_size = 64
	label.label_settings = ls
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2i(0,100)
	v_box.add_child(label)
	label.owner = get_tree().edited_scene_root
	title_label = label

func _add_background() -> void:
	if self.get_node_or_null("Background") != null: return
	var background = ColorRect.new()
	background.name = "Background"
	background.color = Color.WHITE
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	var blur_mat : ShaderMaterial = ResourceLoader.load("uid://c76qunxranfwk")
	background.material = blur_mat.duplicate()
	background.material.set_shader_parameter("mix_percentage",0.7)
	add_child(background)
	background.owner = get_tree().edited_scene_root

func open_panel() -> void:
	animation_player.play(&"toggle")

func close_panel() -> void:
	animation_player.play_backwards(&"toggle")

func set_results(texture_path:String,texture_node:TextureRect,result_name_text:String,result_name_label:Label) -> void:
	if is_instance_valid(texture_node) == false: return printerr("texture_node is not valid")
	if is_instance_valid(result_name_label) == false: return printerr("result_name_label is not valid")
	if not FileAccess.file_exists(texture_path): texture_path = str(Constants.PATHS.get(&"images"),"unknown.png")
	texture_node.texture = ResourceLoader.load(texture_path)
	result_name_label.text = str(result_name_text)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if animation_player == null:
		warnings.append("Animation Player is not set.")
	if title_label == null:
		warnings.append("Title is not set.")
	if exit_button == null:
		warnings.append("Exit Button is not set.")
	
	return warnings
