extends Node

var currentStage:int = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/debug.tscn")
