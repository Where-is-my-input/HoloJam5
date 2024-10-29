extends CharacterBody2D
@onready var tmr_dash: Timer = $tmrDash
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tmr_attack: Timer = $tmrAttack
@onready var virtual_controller: Node = $virtualController
@onready var gura_noises: AudioStreamPlayer2D = $gura_noises
@onready var tmr_idle: Timer = $tmr_idle
@onready var install_progress: TextureProgressBar = $CanvasLayer/install_progress
@onready var blood: Sprite2D = $CanvasLayer/blood
@onready var camera_2d: Camera2D = $Camera2D
@onready var tmr_coyote_jump: Timer = $tmrCoyoteJump

const BUBBLES = preload("res://scenes/vfx/bubbles.tscn")
const SPEED = 300.0
const DASH_SPEED = 1050.0
const JUMP_VELOCITY = -850.0

@export var maxJumps:int = 1
var jumps:int = 1

@export var maxAirDashes:int = 0
var airDashes:int = 1
var dashTimer = 0.3
var attackMovementSpeed:Vector2 = Vector2(8,4)

var facing = 1

@export var trident:bool = false
var attacking:bool = false
var atkTimer:int = 0.25
var hitStop:int = 0

@export var installEnabled:bool = false
var idle = 10

var respawnPosition:Vector2
var dead:bool = false

@export var coyoteJumpBuffer:float = 0.1
var grounded:bool = true

func _ready() -> void:
	respawnPosition = global_position

func installDeactivated():
	print("Install deactivated")
	maxAirDashes = Global.maxDashes
	blood.visible = false

func installActivated():
	print("Install activated")
	maxAirDashes += 1
	blood.visible = true

func _input(event: InputEvent) -> void:
	tmr_idle.start(idle)

func _physics_process(delta: float) -> void:
	
	print(tmr_coyote_jump.time_left)
	if dead: return
	if hitStop > 0:
		hitStop -= 1
	else:
		
		if virtual_controller.dash:
			if is_on_floor() && tmr_dash.is_stopped():
				spawnBubbles()
				gura_noises.playAction()
				virtual_controller.dashed()
				tmr_dash.start(dashTimer)
			elif airDashes > 0:
				spawnBubbles()
				gura_noises.playAction()
				virtual_controller.dashed()
				airDashes -= 1
				tmr_dash.start(dashTimer)
				velocity.y = 0

		if virtual_controller.dashRelease && velocity.x != 0: 
			tmr_dash.stop()
		
		if virtual_controller.jump && (is_on_floor() || jumps > 0 || !tmr_coyote_jump.is_stopped()):
			tmr_coyote_jump.stop()
			grounded = false
			spawnBubbles()
			gura_noises.playAction()
			jumps -= 1
			velocity.y = JUMP_VELOCITY
			virtual_controller.jumped()
			tmr_dash.stop()
		
		if !virtual_controller.jump && virtual_controller.jumpRelease && velocity.y <= 0: velocity.y = 0
		
		if !attacking:
			if !is_on_floor() && tmr_dash.is_stopped():
				velocity += get_gravity() * delta
				if jumps == maxJumps && tmr_coyote_jump.is_stopped(): 
					jumps -= 1
			elif is_on_floor():
				jumps = maxJumps
				airDashes = maxAirDashes
				grounded = true

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
	
	if !is_on_floor() && tmr_coyote_jump.is_stopped() && grounded && jumps > 0 && velocity.y >= 0:
		grounded = false
		tmr_coyote_jump.start(coyoteJumpBuffer)

func attack():
	tmr_attack.start(atkTimer)
	spawnBubbles()
	attacking = true
	velocity = Vector2(facing * SPEED, virtual_controller.direction.y * SPEED) * attackMovementSpeed
	if install_progress.install: velocity *= 1.5
	animation_player.play("attack")

func attackFinished():
	velocity = Vector2(0,0)
	attacking = false

func _on_hitbox_body_entered(body) -> void:
	gura_noises.playHit()
	if installEnabled: install_progress.hit()
	hitStop = 15
	attacking = false
	tmr_attack.stop()
	body.getHit()

func die():
	gura_noises.playDeath()
	#await gura_noises.finished
	dead = true
	install_progress.deactivateInstall()
	Global.deaths += 1
	respawn()

func respawn():
	global_position = respawnPosition
	dead = false

func resetActions():
	airDashes = maxAirDashes
	jumps = maxJumps
	tmr_attack.stop()
	attacking = false
	tmr_dash.stop()

func spawnBubbles():
	for i in randi_range(1, 3):
		var bubble = BUBBLES.instantiate()
		bubble.global_position = Vector2(randi_range(-25, 25), randi_range(-15, 15))
		add_child(bubble)

func _on_tmr_idle_timeout() -> void:
	gura_noises.playIdle()

func setCameraLimits(tilemap, globalPosition):
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.tile_set.tile_size
	camera_2d.limit_left = map_limits.position.x * map_cellsize.x + globalPosition.x
	camera_2d.limit_right = map_limits.end.x * map_cellsize.x + globalPosition.x
	camera_2d.limit_top = map_limits.position.y * map_cellsize.y + globalPosition.y
	camera_2d.limit_bottom = map_limits.end.y * map_cellsize.y + globalPosition.y
