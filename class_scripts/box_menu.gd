@tool
@icon("res://addons/at-icons/control/square.svg")
class_name BoxMenu
extends MarginContainer

signal transition_finished

@export var button_icon : Texture
@export var ignore_add := false
@export var ignore_start_rest := false
@export var rest_position := Vector2(0,-1080)
@export var active_position := Vector2(0,0)
@export_group("Background","background_")
@export var background_const : StringName = &""
@export var background_color : Color = Color(1.0,1.0,1.0,0.4)
@export var background_node : ColorRect
@onready var timer := Timer.new()

func _ready():
	if Engine.is_editor_hint():
		self.mouse_filter = Control.MOUSE_FILTER_STOP
		show()
		modulate = Color.WHITE
		position = Vector2.ZERO
		if background_node != null: 
			if background_const.is_empty() or Constants.BG_COLORS.get(background_const) == null:
				background_node.color = background_color
			else:
				background_node.color = Constants.BG_COLORS[background_const]
	else:
		modulate = Color(1,1,1,0) if not ignore_start_rest else Color(1,1,1,1)
		position = rest_position
		if not ignore_start_rest: slide_out()
		timer.one_shot = true
		timer.wait_time = 0.25
		self.add_child(timer)
		get_tree().root.size_changed.connect(func (): 
			if timer.time_left <= 0.0: timer.start()
			)
		timer.timeout.connect(_reset_position)
		if background_node != null: 
			if background_const.is_empty() or Constants.BG_COLORS.get(background_const) == null:
				background_node.color = background_color
			else:
				background_node.color = Constants.BG_COLORS[background_const]

func _reset_position() -> void:
	if position == Vector2.ZERO and self.modulate != Color.WHITE: position = rest_position

func slide_in(delay:=0.0):
	if GlobalSettings.get_setting(&"General",&"skip_animations"):
		self.modulate = Color.WHITE
		self.position = active_position
		transition_finished.emit()
	else:
		var tween = [get_tree().create_tween(),get_tree().create_tween()]
		tween[0].tween_property(self, "modulate", Color(1,1,1,1), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)
		tween[1].tween_property(self, "position", active_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)
		tween[0].finished.connect(func(): transition_finished.emit())

func slide_out(delay:=0.0):
	if GlobalSettings.get_setting(&"General",&"skip_animations"):
		self.modulate = Color.TRANSPARENT
		self.position = rest_position
		transition_finished.emit()
	else:
		var tween = [get_tree().create_tween(),get_tree().create_tween()]
		tween[0].tween_property(self, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)
		tween[1].tween_property(self, "position", rest_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	return warnings
