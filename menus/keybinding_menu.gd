extends Control

signal hide_menu

var current_button : Button

@onready var jump = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/jump
@onready var jump_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/jump_label
@onready var slide = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer2/slide
@onready var slide_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer2/slide_label
@onready var left = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer3/left
@onready var left_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer3/left_label
@onready var right = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer4/right
@onready var right_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer4/right_label
@onready var dash = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer5/dash
@onready var dash_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer5/dash_label

@onready var controller_left = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/controller_left
@onready var controller_left_label = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/left_label
@onready var controller_right = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer4/controller_right
@onready var controller_right_label = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer4/right_label
@onready var controller_jump = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer/controller_jump
@onready var controller_jump_label = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer/jump_label
@onready var controller_slide = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/controller_slide
@onready var controller_slide_label = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/slide_label
@onready var controller_dash = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer5/controller_dash
@onready var controller_dash_label = $CenterContainer/HBoxContainer/VBoxContainer2/HBoxContainer5/dash_label


@onready var all_buttons = [
	jump,slide,left,right,dash,
	controller_jump,controller_slide,controller_left,controller_right,controller_dash
]

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready():
	_update_labels()
	jump.pressed.connect(_on_button_pressed.bind(jump))
	slide.pressed.connect(_on_button_pressed.bind(slide))
	left.pressed.connect(_on_button_pressed.bind(left))
	right.pressed.connect(_on_button_pressed.bind(right))
	dash.pressed.connect(_on_button_pressed.bind(dash))
	controller_jump.pressed.connect(_on_button_pressed.bind(controller_jump))
	controller_slide.pressed.connect(_on_button_pressed.bind(controller_slide))
	controller_left.pressed.connect(_on_button_pressed.bind(controller_left))
	controller_right.pressed.connect(_on_button_pressed.bind(controller_right))
	controller_dash.pressed.connect(_on_button_pressed.bind(controller_dash))

func _on_button_pressed(button:Button):
	disable_buttons(true)
	current_button = button
	panel_container.show()

func _input(event):
	if !current_button:
		return
	if current_button.is_in_group("keyboard"):
		if event is InputEventKey || event is InputEventMouseButton:
			var all_ies : Dictionary = {}
			for ia in InputMap.get_actions():
				for iae in InputMap.action_get_events(ia):
					all_ies[iae.as_text()] = ia
			if all_ies.keys().has(event.as_text()):
				InputMap.action_erase_events(all_ies[event.as_text()])
			InputMap.action_erase_events(current_button.name)
			InputMap.action_add_event(current_button.name,event)
			current_button = null
			panel_container.hide()
			_update_labels()
			await get_tree().create_timer(.5).timeout
			disable_buttons(false)
	if current_button.is_in_group("controller"):
		if event is InputEventJoypadButton || event is InputEventJoypadMotion:
			var all_ies : Dictionary = {}
			for ia in InputMap.get_actions():
				for iae in InputMap.action_get_events(ia):
					all_ies[iae.as_text()] = ia
			if all_ies.keys().has(event.as_text()):
				InputMap.action_erase_events(all_ies[event.as_text()])
			InputMap.action_erase_events(current_button.name)
			InputMap.action_add_event(current_button.name,event)
			current_button = null
			panel_container.hide()
			_update_labels()
			await get_tree().create_timer(.5).timeout
			disable_buttons(false)

@onready var key_data = [
	{
		"name":"jump",
		"label":jump_label
	},
	{
		"name":"slide",
		"label":slide_label
	},
	{
		"name":"left",
		"label":left_label
	},
	{
		"name":"right",
		"label":right_label
	},
	{
		"name":"dash",
		"label":dash_label
	},
	{
		"name":"controller_jump",
		"label":controller_jump_label
	},
	{
		"name":"controller_slide",
		"label":controller_slide_label
	},
	{
		"name":"controller_left",
		"label":controller_left_label
	},
	{
		"name":"controller_right",
		"label":controller_right_label
	},
	{
		"name":"controller_dash",
		"label":controller_dash_label
	},
]

func _update_labels():
	for data in key_data:
		var button : Array[InputEvent] = InputMap.action_get_events(data["name"])
		if !button.is_empty():
			data["label"].text = button[0].as_text()
		else:
			data["label"].text = ""

func _on_back_button_pressed():
	hide_menu.emit()
	hide()

func disable_buttons(disable):
	for button in all_buttons:
		button.disabled = disable
