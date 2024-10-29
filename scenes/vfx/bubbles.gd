extends Sprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	var s = randf_range(0.001, 0.05)
	scale = Vector2(s, s)

func _physics_process(delta: float) -> void:
	global_position += Vector2(randi_range(-25, 25), -10)

func _on_timer_timeout() -> void:
	queue_free()
