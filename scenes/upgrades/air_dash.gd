extends Area2D

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.maxAirDashes += 1
		Global.maxDashes += 1
		queue_free()
	
