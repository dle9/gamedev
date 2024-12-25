extends Node2D


@onready var intro_panel = $MarginContainer/MarginContainer/IntroPanel
@onready var username_edit = $MarginContainer/MarginContainer/VBoxContainer/UsernameContainer/UsernameEdit
@onready var title_container = $MarginContainer/MarginContainer/VBoxContainer/TitleContainer
@onready var title = $MarginContainer/MarginContainer/VBoxContainer/TitleContainer/MarginContainer/CenterContainer/TitleLabel
@onready var color_picker = $MarginContainer/MarginContainer/VBoxContainer/ColorPickerContainer/MarginContainer/Sprite2D/ColorPickerButton
@onready var selected_color = Globals.colors["white"]
@onready var warning_label_1 = $MarginContainer/MarginContainer/VBoxContainer/WarningContainer1/CenterContainer/WarningLabel1
@onready var warning_label_2 = $MarginContainer/MarginContainer/VBoxContainer/WarningContainer2/CenterContainer/WarningLabel2
var confirm_choices = false		# first enter pressed
var warnings_on = false


func _ready() -> void:
	color_picker.color = Globals.colors["white"]


func _process(delta: float) -> void:
	# controls
	if Input.is_action_just_pressed("ui_accept"):
		username_edit.release_focus()
		if !warnings_on and !confirm_choices:
			confirm_choices = true
			warnings_on = true
			toggle_warnings()
		elif confirm_choices:
			confirmed() # go to next scene!
	elif Input.is_action_just_pressed("tab"):
		username_edit.grab_focus()
	elif Input.is_action_just_pressed("esc"):
		if warnings_on and confirm_choices:
			warnings_on = false
			confirm_choices = false
			toggle_warnings()
			
	# theme color stuff
	if color_picker.color and (color_picker.color != selected_color):
		set_theme()
	
	
func set_theme() -> void:
	intro_panel.get_theme_stylebox("panel").border_color = color_picker.color
	title.add_theme_color_override("font_color", color_picker.color)
	selected_color = color_picker.color


func toggle_warnings():
	var tween = create_tween()

	var dest = Vector2(0, 0)
	if warnings_on:
		dest = title_container.position + Vector2(0, 20)
	else:
		dest = title_container.position - Vector2(0, 20)

	tween.tween_property(title_container, "position", dest, 3)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)

	warning_label_1.visible = !warning_label_1.visible
	warning_label_2.visible = !warning_label_2.visible

	
func confirmed():
	'''user presses accept twice'''
	pass
