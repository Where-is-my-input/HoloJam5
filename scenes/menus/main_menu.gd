extends Control
@onready var credits: Control = $credits
@onready var play: Button = $MarginContainer/VBoxContainer/play
@onready var palette_editor: HBoxContainer = $paletteEditor

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		palette_editor.visible = true
