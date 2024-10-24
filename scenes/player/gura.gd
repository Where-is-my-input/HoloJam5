extends CharacterBody2D
@onready var tmr_dash: Timer = $tmrDash
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tmr_attack: Timer = $tmrAttack

const SPEED = 300.0
const DASH_SPEED = 650.0
const JUMP_VELOCITY = -850.0

@export var maxJumps:int = 2
var jumps:int = 1

@export var maxAirDashes:int = 1
var airDashes:int = 1
var dashTimer = 0.3
var attackMovementSpeed:Vector2 = Vector2(8,4)

var facing = 1
var attacking:bool = false
var atkTimer:int = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && (is_on_floor() || jumps > 0):
		jumps -= 1
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_cancel"):
		if is_on_floor() && tmr_dash.is_stopped():
			tmr_dash.start(dashTimer)
		elif airDashes > 0:
			airDashes -= 1
			tmr_dash.start(dashTimer)

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if !attacking:
		if !is_on_floor():
			velocity += get_gravity() * delta
			if jumps == maxJumps: jumps -= 1
		else:
			jumps = maxJumps
			airDashes = maxAirDashes

		if direction:
			
			if direction != facing:
				facing = direction
				scale.x *= -1
			
			velocity.x = direction * SPEED if tmr_dash.is_stopped() else direction * (DASH_SPEED + SPEED * tmr_dash.time_left)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") && tmr_attack.is_stopped():
		attack(Input.get_axis("ui_up", "ui_down"))

	move_and_slide()

func attack(directionY = 0):
	tmr_attack.start(atkTimer)
	attacking = true
	velocity = Vector2(facing * SPEED, directionY * SPEED) * attackMovementSpeed
	animation_player.play("attack")

func attackFinished():
	velocity = Vector2(0,0)
	attacking = false
