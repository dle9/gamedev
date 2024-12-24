extends Node2D


var Enemy = preload("res://enemy.tscn")
var game_time = 0
@onready var game_time_label = get_node("GameTimeContainer/HBoxContainer/Label")


func _ready() -> void:
	Globals.row0_label.text = Globals.row_legend[0]
	Globals.row1_label.text = Globals.row_legend[1]
	Globals.row2_label.text = Globals.row_legend[2]
	Globals.row3_label.text = Globals.row_legend[3]
	Globals.row4_label.text = Globals.row_legend[4]
	Globals.row5_label.text = Globals.row_legend[5]
	Globals.row6_label.text = Globals.row_legend[6]
	Globals.row7_label.text = Globals.row_legend[7]
	Globals.row8_label.text = Globals.row_legend[8]
	
	update_timer_display()


func _process(delta: float) -> void:
	pass


func spawn_enemy() -> void:
	var e = Enemy.instantiate()
	e.position.x = Globals.enemy_pos_x[randi() % Globals.enemy_pos_x.size()]
	e.position.y = Globals.calc_row_pos_y(randi() % 9)
	
	get_parent().add_child(e)


func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]
	
	
func update_timer_display() -> void:
	game_time_label.text = format_time(game_time)
	

func _on_enemy_timer_timeout() -> void:
	spawn_enemy()


func _on_game_timer_timeout() -> void:
	game_time += 1
	update_timer_display()