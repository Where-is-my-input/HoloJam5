extends Area2D


func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		Global.currentStage += 1
		get_tree().change_scene_to_file("res://scenes/stages/load_stage.tscn")
