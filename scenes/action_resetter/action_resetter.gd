extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var tmr_respawn: Timer = $tmrRespawn
@export var respawn:float = 3

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.resetActions()
		spawnState()
		tmr_respawn.start(respawn)

func _on_tmr_respawn_timeout() -> void:
	spawnState(true)

func spawnState(v = false):
	collision_shape_2d.set_deferred("disabled", !v)
	visible = v
