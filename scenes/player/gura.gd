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
@onready var tridentSprite: AnimatedSprite2D = $trident
@onready var tmr_respawn: Timer = $tmrRespawn

const BUBBLES = preload("res://scenes/vfx/bubbles.tscn")
const SPEED = 300.0
const DASH_SPEED = 1050.0
const JUMP_VELOCITY = -850.0

@export var maxJumps:int = 1
var jumps:int = 1

@export var maxAirDashes:int = 0
var airDashes:int = 1
var dashTimer = 0.3
var attackMovementSpeed:Vector2 = Vector2(8,6)

var facing = 1

@export var trident:bool = false
@export var attacking:bool = false
var atkTimer:float = 0.5
var hitStop:int = 0

@export var installEnabled:bool = false
var idle = 10

var respawnPosition:Vector2
var dead:bool = false

@export var coyoteJumpBuffer:float = 0.1
var grounded:bool = true

func _ready() -> void:
	setDefaultPalette()
	tridentSprite.visible = trident
	respawnPosition = global_position

func setDefaultPalette():
	material.set("shader_parameter/newColor1", Global.palette[0])
	material.set("shader_parameter/newColor2", Global.palette[1])
	material.set("shader_parameter/newColor3", Global.palette[2])
	material.set("shader_parameter/newColor4", Global.palette[3])

func setPalette(color1, color2, color3, color4):
	material.set("shader_parameter/newColor1", color1)
	material.set("shader_parameter/newColor2", color2)
	material.set("shader_parameter/newColor3", color3)
	material.set("shader_parameter/newColor4", color4)

func installDeactivated():
	setDefaultPalette()
	maxAirDashes = Global.maxDashes
	blood.visible = false

func installActivated():
	setPalette(Color(0.914, 0.129, 0.173, 1), Color(0.761, 0.082, 0.192, 1), Global.palette[2], Color(0.914, 0.129, 0.173))
	maxAirDashes += 1
	blood.visible = true

func _input(event: InputEvent) -> void:
	tmr_idle.start(idle)

func _physics_process(delta: float) -> void:
	if dead: return
	if hitStop > 0:
		hitStop -= 1
		animation_player.speed_scale = 0
		velocity.x += SPEED * facing
		if hitStop <= 0:
			attackFinished()
			setAnimation()
			#attacking = false
			#tmr_attack.stop()
			animation_player.speed_scale = 1
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
			#animation_player.play("jump")
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
				if !tmr_dash.is_stopped():
					spawnBubbles(1)
				#else:
					#animation_player.play("dash")
				
				if virtual_controller.direction.x != facing:
					facing = virtual_controller.direction.x
					scale.x *= -1
				
				velocity.x = virtual_controller.direction.x * SPEED if tmr_dash.is_stopped() else virtual_controller.direction.x * (DASH_SPEED + SPEED * tmr_dash.time_left)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		#print(virtual_controller.attack, tmr_attack.is_stopped(), !attacking)
		if virtual_controller.attack && trident && tmr_attack.is_stopped() && !attacking:
			attack()

		setAnimation()
		
		move_and_slide()
		
		if !is_on_floor() && tmr_coyote_jump.is_stopped() && grounded && jumps > 0 && velocity.y >= 0:
			grounded = false
			tmr_coyote_jump.start(coyoteJumpBuffer)

func setAnimation():
	if !attacking:
		if is_on_floor():
			if virtual_controller.direction.x:
				if tmr_dash.is_stopped():
					animation_player.play("run")
				else:
					animation_player.play("dash")
			elif animation_player.current_animation != "idle" && animation_player.current_animation != "a": 
				animation_player.play("idle")
		else:
			if !tmr_dash.is_stopped():
				animation_player.play("dash")
			else:
				animation_player.play("jump")
		

func attack():
	tmr_attack.start(atkTimer)
	spawnBubbles()
	attacking = true
	if install_progress.install:
		velocity = Vector2(virtual_controller.direction.x * SPEED, virtual_controller.direction.y * SPEED) * attackMovementSpeed
	else:
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
	spawnBubbles(10)
	velocity.y = SPEED * virtual_controller.direction.y
	attacking = false
	tmr_attack.start(0.06)
	body.getHit()

func die():
	gura_noises.playDeath()
	#await gura_noises.finished
	dead = true
	install_progress.deactivateInstall()
	attacking = false
	tmr_respawn.start(0.1)
	#respawn()

func respawn():
	attacking = false
	resetActions()
	animation_player.play("idle")
	global_position = respawnPosition
	await get_tree().create_timer(0.1).timeout
	Global.deaths += 1
	dead = false

func resetActions():
	#velocity = Vector2(0,0)
	airDashes = maxAirDashes
	jumps = maxJumps
	tmr_attack.stop()
	attacking = false
	tmr_dash.stop()

func spawnBubbles(range = 3):
	for i in randi_range(1, range):
		var bubble = BUBBLES.instantiate()
		bubble.global_position = global_position + Vector2(randi_range(-25, 25), randi_range(-15, 15))
		add_sibling(bubble)

func _on_tmr_idle_timeout() -> void:
	gura_noises.playIdle()
	animation_player.play("a")

func setCameraLimits(tilemap, globalPosition):
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.tile_set.tile_size
	camera_2d.limit_left = map_limits.position.x * map_cellsize.x + globalPosition.x
	camera_2d.limit_right = map_limits.end.x * map_cellsize.x + globalPosition.x
	camera_2d.limit_top = map_limits.position.y * map_cellsize.y + globalPosition.y
	camera_2d.limit_bottom = map_limits.end.y * map_cellsize.y + globalPosition.y


func _on_tmr_attack_timeout() -> void:
	#animation_player.play("idle")
	setAnimation()
	attacking = false
