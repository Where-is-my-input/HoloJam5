extends TextureProgressBar
@onready var timer: Timer = $Timer

@export var increase:int = 5

var install:bool = false
var decay = 0
var combo = 0

signal installActivated
signal installDeactivated

func _on_timer_timeout() -> void:
	decay += 5
	combo = 0
	value -= decay
	visible = value > 0
	if value <= 0 && install: 
		install = false
		installDeactivated.emit()
		value = 0
	else:
		timer.start(1)

func hit():
	decay = 0
	combo += 1
	value += increase * combo
	timer.start(3)
	visible = value > 0
	if !install:
		install = value >= max_value
		if install: 
			installActivated.emit()
