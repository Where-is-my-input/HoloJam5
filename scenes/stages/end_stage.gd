extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		Global.currentStage += 1
		get_tree().change_scene_to_file("res://scenes/stages/load_stage.tscn")


func _on_timer_timeout() -> void:
	sprite_2d.rotate(25)
