class_name BoxMenu
extends Control

@export var ignore_start_rest := false
@export var rest_position := Vector2(0,-1080)
@export var active_position := Vector2(0,0)

func _ready():
	show()
	modulate = Color(1,1,1,0)
	position = rest_position if ignore_start_rest == false else position

func slide_in(delay:=0.0):
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self, "modulate", Color(1,1,1,1), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)
	tween[1].tween_property(self, "position", active_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(delay)

func slide_out(delay:=0.0):
	var tween = [get_tree().create_tween(),get_tree().create_tween()]
	tween[0].tween_property(self, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)
	tween[1].tween_property(self, "position", rest_position, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)
