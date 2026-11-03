@tool
@icon("res://addons/at-icons/control/square.svg")
class_name BoxMenu
extends MarginContainer

@export var ignore_add := false
@export var ignore_start_rest := false
@export var rest_position := Vector2(0,-1080)
@export var active_position := Vector2(0,0)

func _ready():
	if Engine.is_editor_hint():
		self.mouse_filter = Control.MOUSE_FILTER_STOP
		show()
		modulate = Color.WHITE
		position = Vector2.ZERO
	else:
		modulate = Color(1,1,1,0) if not ignore_start_rest else Color(1,1,1,1)
		position = rest_position
		if not ignore_start_rest: slide_out()
		get_tree().root.size_changed.connect(func (): 
			await get_tree().create_timer(0.1).timeout
			if position == Vector2.ZERO and self.modulate != Color.WHITE: position = rest_position
			)

func slide_in(delay:=0.0):
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self, "modulate", Color(1,1,1,1), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)
	tween[1].tween_property(self, "position", active_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)

func slide_out(delay:=0.0):
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)
	tween[1].tween_property(self, "position", rest_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	return warnings
