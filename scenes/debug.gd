extends Node2D



func _on__pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/stage_1.tscn")
