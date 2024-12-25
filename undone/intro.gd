extends Node2D


@onready var title_container = $CustomizeContainer/MarginContainer/VBoxContainer/TitleContainer
@onready var username_container = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer/HBoxContainer
@onready var username_margin_container = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer
@onready var color_picker_container = $CustomizeContainer/MarginContainer/VBoxContainer/ColorPickerContainer/MarginContainer

@onready var intro_panel = $CustomizeContainer/MarginContainer/IntroPanel
@onready var username_panel = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer/UsernamePanel
@onready var title_panel = $CustomizeContainer/MarginContainer/VBoxContainer/TitleContainer/MarginContainer/Panel

@onready var username_edit = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer/UsernameEdit
@onready var username_label	 = $CustomizeContainer/MarginContainer/VBoxContainer/UsernameContainer/HBoxContainer/UsernameLabel
@onready var title_label = $CustomizeContainer/MarginContainer/VBoxContainer/TitleContainer/MarginContainer/CenterContainer/TitleLabel
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
	title_label.add_theme_color_override("font_color", color_picker.color)
	selected_color = color_picker.color
	
	
func toggle_warnings():
	var dest = Color(1, 1, 1, 1)
	if !warning_showing:
		dest = Color(1, 1, 1, 0)
	Utils.tween_fade(warning_label_1, "theme_override_colors/font_color", dest, 0.3)
	Utils.tween_fade(warning_label_2, "theme_override_colors/font_color", dest, 0.3)
	
		
func confirmed():
	'''user presses accept twice'''
	# set the user customization
	Globals.theme_color = selected_color
	Globals.username = username_edit.text
	username_label.text = username_edit.text
	
	# dramatic intro to scene 2
	hide_intro_elements()
	var tween_title = create_tween()
	tween_title.tween_property(title_label, "modulate:a", 0, 0.9)
	await tween_title.finished
	
	# update the window size
	var tween_window = create_tween()
	tween_window.tween_property(get_window(), "size", Vector2i(1500, 900), 0.9)
	await tween_window.finished
	
	# hide old container
	$CustomizeContainer.modulate.a = 0
	
	# do some intermedeiary text
	
	# switch to terminal scene
	#get_tree().change_scene_to_file("res://main.tscn")
	
	
func hide_intro_elements():
	var tween = create_tween()
	tween.tween_property(intro_panel, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(username_edit, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(username_label, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(username_panel, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(title_panel, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(color_picker_container, "modulate:a", 0, 0.3)
	tween.parallel().tween_property(warning_label_1, "theme_override_colors/font_color", Color(1, 1, 1, 0), 0.3)
	tween.parallel().tween_property(warning_label_2, "theme_override_colors/font_color", Color(1, 1, 1, 0), 0.3)
	await tween.finished
