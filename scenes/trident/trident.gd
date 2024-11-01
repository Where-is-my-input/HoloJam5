extends Area2D

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		Global.trident = true
		body.trident = true
		body.tridentSprite.visible = true
		queue_free()
