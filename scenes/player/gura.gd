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
var attacking:bool = false
var atkTimer:int = 1
var hitStop:int = 0

func _physics_process(delta: float) -> void:
	if hitStop > 0:
		hitStop -= 1
		#TODO Input buffer - Virtual controller
		#if hitStop == 0: attackDirection(Input.get_axis("ui_up", "ui_down"))
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

		var direction := Input.get_axis("ui_left", "ui_right")
		
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

			if direction:
				
				if direction != facing:
					facing = direction
					scale.x *= -1
				
				velocity.x = direction * SPEED if tmr_dash.is_stopped() else direction * (DASH_SPEED + SPEED * tmr_dash.time_left)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if virtual_controller.attack && tmr_attack.is_stopped():
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

func _on_hitbox_body_entered(body) -> void:
	hitStop = 15
	attacking = false
	tmr_attack.stop()

func attackDirection(directionY = 0):
	velocity = Vector2(facing * SPEED * 2, directionY * SPEED) * attackMovementSpeed
	animation_player.play("followUp")
	#match directionY:
		#1:
			#animation_player.play("attack")
		#-1:
			#animation_player.play("attack")
		#_:
			#animation_player.play("attack")
