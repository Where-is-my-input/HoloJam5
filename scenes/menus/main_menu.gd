extends Control
@onready var credits: Control = $credits
@onready var play: Button = $MarginContainer/VBoxContainer/play

func _ready() -> void:
	play.grab_focus()

func _on_play_pressed() -> void:
	Global.reset()
	Global.setBGM()
	get_tree().change_scene_to_file("res://scenes/stages/load_stage.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")


func _on_credits_pressed() -> void:
	credits.visible = true
