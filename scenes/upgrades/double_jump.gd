extends Area2D


func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.maxJumps += 1
		Global.maxJumps += 1
		queue_free()
