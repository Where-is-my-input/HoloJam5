extends CharacterBody2D
@onready var tmr_dash: Timer = $tmrDash
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tmr_attack: Timer = $tmrAttack
@onready var virtual_controller: Node = $virtualController

const SPEED = 300.0
const DASH_SPEED = 1050.0
const JUMP_VELOCITY = -850.0

@export var maxJumps:int = 2
var jumps:int = 1

@export var maxAirDashes:int = 1
var airDashes:int = 1
var dashTimer = 0.3
var attackMovementSpeed:Vector2 = Vector2(8,4)

var facing = 1

@export var trident:bool = true
var attacking:bool = false
var atkTimer:int = 1
var hitStop:int = 0

func _physics_process(delta: float) -> void:
	if hitStop > 0:
		hitStop -= 1
	else:
		
		if virtual_controller.dash:
			if is_on_floor() && tmr_dash.is_stopped():
				virtual_controller.dashed()
				tmr_dash.start(dashTimer)
			elif airDashes > 0:
				virtual_controller.dashed()
				airDashes -= 1
				tmr_dash.start(dashTimer)
				velocity.y = 0
		
		if virtual_controller.jump && (is_on_floor() || jumps > 0):
			jumps -= 1
			velocity.y = JUMP_VELOCITY
			virtual_controller.jumped()
			tmr_dash.stop()
		
		if !attacking:
			if !is_on_floor() && tmr_dash.is_stopped():
				velocity += get_gravity() * delta
				if jumps == maxJumps: jumps -= 1
			elif is_on_floor():
				jumps = maxJumps
				airDashes = maxAirDashes

			if virtual_controller.direction.x:
				
				if virtual_controller.direction.x != facing:
					facing = virtual_controller.direction.x
					scale.x *= -1
				
				velocity.x = virtual_controller.direction.x * SPEED if tmr_dash.is_stopped() else virtual_controller.direction.x * (DASH_SPEED + SPEED * tmr_dash.time_left)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if virtual_controller.attack && trident && tmr_attack.is_stopped():
			attack()

	move_and_slide()

func attack():
	tmr_attack.start(atkTimer)
	attacking = true
	velocity = Vector2(facing * SPEED, virtual_controller.direction.y * SPEED) * attackMovementSpeed
	animation_player.play("attack")

func attackFinished():
	velocity = Vector2(0,0)
	attacking = false

func _on_hitbox_body_entered(body) -> void:
	hitStop = 15
	attacking = false
	tmr_attack.stop()
