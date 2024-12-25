extends Node2D


@onready var title_container = $CustomizeContainer/MarginContainer/VBoxContainer/TitleContainer
@onready var intro_panel = $CustomizeContainer/MarginContainer/IntroPanel

@onready var username_edit = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer/UsernameEdit
@onready var title = $CustomizeContainer/MarginContainer/VBoxContainer/TitleContainer/MarginContainer/CenterContainer/TitleLabel
@onready var color_picker = $CustomizeContainer/MarginContainer/VBoxContainer/ColorPickerContainer/MarginContainer/Sprite2D/ColorPickerButton
@onready var warning_label_1 = $CustomizeContainer/MarginContainer/VBoxContainer/WarningContainer1/CenterContainer/WarningLabel1
@onready var warning_label_2 = $CustomizeContainer/MarginContainer/VBoxContainer/WarningContainer2/CenterContainer/WarningLabel2
@onready var selected_color = Globals.colors["white"]
var confirm_choices = false # first enter pressed
var warning_showing = false


func _ready() -> void:
	color_picker.color = Globals.colors["white"]


func _process(delta: float) -> void:
	# controls
	if Input.is_action_just_pressed("ui_accept"):
		if !warning_showing and !confirm_choices and username_edit.has_focus() and username_edit.text.length() > 0:
			confirm_choices = true
			warning_showing = true
			toggle_warnings()
		elif confirm_choices:
			confirmed() # go to next scene!
		username_edit.release_focus()
	elif Input.is_action_just_pressed("tab"):
		username_edit.grab_focus()
	elif Input.is_action_just_pressed("esc"):
		if warning_showing and confirm_choices:
			warning_showing = false
			confirm_choices = false
			toggle_warnings()
			
	# theme customization
	if color_picker.color and (color_picker.color != selected_color):
		set_theme()
	
	
func set_theme() -> void:
	intro_panel.get_theme_stylebox("panel").border_color = color_picker.color
	title.add_theme_color_override("font_color", color_picker.color)
	selected_color = color_picker.color
	
	
func toggle_warnings():
	var dest = Color(1, 1, 1, 1)
	if !warning_showing:
		dest = Color(1, 1, 1, 0)
	Utils.fade(warning_label_1, "theme_override_colors/font_color", dest, 0.3)
	Utils.fade(warning_label_2, "theme_override_colors/font_color", dest, 0.3)
	
		
func confirmed():
	'''user presses accept twice'''
	# update the viewport
	var tween = create_tween()
	var window = get_window()
	tween.tween_property(window, "size", Vector2i(1680, 1050), 0.9)
	
	# set the user customization
	Globals.theme_color = selected_color
	Globals.username = username_edit.text
	
	# hide relevant nodes
	Utils.fade(intro_panel, "theme_override_colors/bg_color", Color(1, 1, 1, 0), 0.3)
	
