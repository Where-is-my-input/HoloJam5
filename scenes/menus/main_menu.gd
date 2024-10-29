extends Control


func _on_play_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_file("res://scenes/stages/load_stage.tscn")
