extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var maxJumps:int = 2
var jumps:int = 2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if jumps == maxJumps: jumps -= 1
	else:
		jumps = maxJumps

	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || jumps > 0):
		jumps -= 1
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
