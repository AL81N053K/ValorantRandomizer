extends Control

@export var menu_container : MenuContainer
@export var side_menu : Control

func _ready() -> void:
	for child : BoxMenu in menu_container.get_children():
		if not child.ignore_add:
			var button = BoxLinkButton.new()
			button.box_to_link = child
			button.text = str(child.name.to_camel_case().capitalize())
			button.name = str(child.name,"Button")
			side_menu.button_list.add_child(button)
			button.set_owner(side_menu.button_list)
			button.box_link_pressed.connect(menu_container.change_panel)
			button.pressed.connect(side_menu.toggle_menu)
