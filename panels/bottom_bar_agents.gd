extends BottomBar

@export_group("Buttons","button_")
@export var button_controller : Button
@export var button_duelist : Button
@export var button_initiator : Button
@export var button_sentinel : Button
@export_group("Lists","list_")
@export var list_controller : Array[StringName]
@export var list_duelist : Array[StringName]
@export var list_initiator : Array[StringName]
@export var list_sentinel : Array[StringName]
@export var randomizer_handler : RandomizerHandler

func _ready() -> void:
	button_controller.pressed.connect(_button_pressed.bind("controller"))
	button_duelist.pressed.connect(_button_pressed.bind("duelist"))
	button_initiator.pressed.connect(_button_pressed.bind("initiator"))
	button_sentinel.pressed.connect(_button_pressed.bind("sentinel"))
	
	self.ready.connect(func (): 
		await get_tree().create_timer(0.1).timeout
		_add_default_preset("controller",list_controller)
		_add_default_preset("duelist",list_duelist)
		_add_default_preset("initiator",list_initiator)
		_add_default_preset("sentinel",list_sentinel)
		)
	

func _button_pressed(what:StringName) -> void:
	if randomizer_handler != null:
		randomizer_handler.file_path = str("user://default_",what,".val")
		randomizer_handler.load_preset()

func _add_default_preset(preset_name:String,list:Array) -> void:
	randomizer_handler.file_path = str("user://default_",preset_name,".val")
	randomizer_handler.rng_list.clear()
	for panel : ContentPanel in randomizer_handler.list_of_panels:
		for object : Button in panel.grid.get_children():
			if list.has(object.text):
				randomizer_handler.rng_list.append(object)
	
	var save_data : Dictionary = {}
	save_data.set(&"type",&"agent")
	save_data.set(&"list",list)
	
	var file = FileAccess.open(randomizer_handler.file_path,FileAccess.WRITE)
	if file == null: randomizer_handler.show_error(str("Error while creating a file. ",FileAccess.get_open_error()))
	var json_sting := JSON.stringify(save_data)
	file.store_string(json_sting)
